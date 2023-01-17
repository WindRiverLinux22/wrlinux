#!/usr/bin/env python3
"""
 bootlogParser.py - Boot Log Download and Parsing Routines
"""

"""
 Copyright (c) 2022 Wind River Systems, Inc.

 SPDX-License-Identifier: MIT
"""

import re
import json
import bootlogConst
from dataclasses import dataclass, asdict
import tftpy
import ipaddress
import io
from contextlib import redirect_stderr

#File Constants
FLAG_BEGIN =    0xAA
FLAG_END =      0x55
FLAG_INSTANT =  0x01
MOD_VM_INIT_EVT = 0x117

HV_PID_BASE =   0x4856
VX_PID_BASE =   0x5658

TS_SCALE_FACTOR = 1000000

HV_FNAME = 'hv_bootlog'
VX_FNAME = 'vx_bootlog'
OUT_FNAME = 'VxBootTF'

@dataclass
class traceObj:
    name: str
    ph:   str
    ts:   int
    dur:  int
    pid:  int
    tid:  int
    args: object

@dataclass
class logArgs:
    core:           int
    modId:          int
    level:          int
    usrBits_start:  int
    usrBits_end:    int

@dataclass
class metaPidEvt:
    name: str
    ph:   str
    pid:  int
    args: object

@dataclass
class metaTidEvt:
    name: str
    ph:   str
    pid:  int
    tid:  int
    args: object

@dataclass
class metaArgs:
    name: str

class VxBootTF(object):
    def __init__(self):
        self.events = []
        self.txtFiles = []

    def logFileToJSON(self, filepath, vmID = 1):
        """
        Read and parse a boot log event file downloaded from target
        """
        pending_logs = []
        mem_core = set()
        mem_tid = set()
        pid_base = VX_PID_BASE * vmID

        # open file for reading
        with open(filepath, 'r') as file:
            for line in file:
                traceLn, event_flags = self.parseTxtLog(line, pid_base)

                # check if this is the HV log file
                if line.find("Hypervisor earlyLogInit") >= 0:
                    pid_base = HV_PID_BASE
                    
                    # re-parse with the correct PID value
                    traceLn, event_flags = self.parseTxtLog(line, pid_base)
                
                if traceLn.args.core not in mem_core:
                    mem_core.add(traceLn.args.core)
                
                if traceLn.tid not in mem_tid:
                    mem_tid.add(traceLn.tid)

                if event_flags is FLAG_BEGIN:
                    # add to pending list until we find corresponding FLAG_END
                    pending_logs.append(traceLn)

                elif event_flags is FLAG_END:
                    # check pending_logs for corresponding message ID
                    msg_id = [traceLn.args.core, traceLn.args.modId, traceLn.args.level]
                    for idx, log in reversed(list(enumerate(pending_logs))):
                        if (log.args.core == msg_id[0]) and (log.args.modId == msg_id[1]) and (log.args.level == msg_id[2]):
                            # found match, remove from pending list
                            x_event = pending_logs.pop(idx)
                            x_event.dur = traceLn.ts - x_event.ts
                            x_event.args.usrBits_end = traceLn.args.usrBits_start
                            yield x_event
                            break
                else:
                    yield traceLn

        # output the metadata items at the end
        for core in mem_core:
            yield self.printMetadataEvent(vmID, pid_base, -1, core)
            for tid in mem_tid:
                yield self.printMetadataEvent(vmID, pid_base, tid, core)


    def parseTxtLog(self, log, pid_base):
        """
        Parse a single boot log, returning a populated dataclass object
        """
        logParts = re.split('\[|\]|,|:|\n', log)

        if len(logParts) < 9:
            return '', 0

        ts_str = logParts[1].strip()
        
        if is_number(ts_str):
            ts =        int(float(ts_str.strip()) * TS_SCALE_FACTOR)
            coreNum =   int(logParts[2].replace("Core", "").strip())
            frameNum =  int(logParts[3].replace("Msg", "").strip())
            modId =     int(logParts[4])
            lvl =       int(logParts[5])
            usrBits =   int(logParts[6])
            flags =     int(logParts[7], 16)
            msg =       logParts[8].lstrip()

            pid = pid_base + coreNum
            tid = modId & 0xFF00
            argObj = logArgs(coreNum, modId, lvl, usrBits, 0)

            return traceObj(msg, 'X', ts, 0, pid, tid, argObj), flags

        return '', 0

    def printMetadataEvent(self, vmID, pid, tid, core):
        """
        Create and return a new process_name or thread_name metadata event object
        """

        if pid == HV_PID_BASE:
            namePrefix = "HV-"
            modIdDict = bootlogConst.HV_MODS
        else:
            namePrefix = "VM%d-" % vmID
            modIdDict = bootlogConst.VX_MODS

        if tid == -1:
            coreNumStr = "Core%d" % core
            argObj = metaArgs(namePrefix + coreNumStr)
            return metaPidEvt("process_name", "M", pid+core, argObj)

        else:
            if tid not in modIdDict:
                tid &= 0xFF00

            if tid not in modIdDict:
                nameStr = "Unknown thread"
            else:
                nameStr = modIdDict[tid]
                
            argObj = metaArgs(nameStr)
            return metaTidEvt("thread_name", "M", pid+core, tid, argObj)

    def download(self, targetIP):
        """
        Use TFTP to download all of the VxWorks (and Hypervisor if it exists)
        boot log files. 
        """
        client = tftpy.TftpClient(targetIP)
        
        print("\nStarting Download...")

        # first try to get the hypervisor logs if they exist
        try:
            client.download(HV_FNAME, HV_FNAME, timeout=10, retries=2)
            self.txtFiles.append((HV_FNAME, 0))
            print("\nhv_bootlog file downloaded")
        except tftpy.TftpException as e:
            # if the file is simply not found, continue on - otherwise raise the exception higher
            # file-not-found could simply indicate this is a native VxWorks/Linux with no hypervisor
            if type(e) is not tftpy.TftpFileNotFoundError:
                raise e

        # do same for the default VxWorks file name
        try:
            client.download(VX_FNAME, VX_FNAME, timeout=10, retries=2)
            self.txtFiles.append((VX_FNAME, 1))
            print("\nvx_bootlog file downloaded")
        except tftpy.TftpException as e:
            if type(e) is not tftpy.TftpFileNotFoundError:
                raise e

        # Handle the case of multiple VxWorks guests:
        # - Expect boot log filenames to be a combination of the base name + vmId.
        # - VM IDs are not guaranteed to be a perfect sequence, as there may be 1 or more Linux guests.
        # - Iterate until 5 consecutive VM ID values return a FileNotFound error.
        vmId = 1
        connectFailureCnt = 0
        while True:
            try:
                fname = VX_FNAME + str(vmId)
                client.download(fname, fname, timeout=10, retries=2)
                self.txtFiles.append((fname, vmId))
                print("\n%s file downloaded" % fname)
            except tftpy.TftpException as e:
                if type(e) is tftpy.TftpFileNotFoundError:
                    connectFailureCnt += 1
                    if connectFailureCnt >= 5:
                        break
                else:
                    raise e
            vmId += 1
    
    def getLogs(self, targetIP):
        """
        """
        # validate the target IP address
        try:
            ipaddress.ip_address(targetIP)
        except ValueError as e:
            print("\nInvalid address specified. Expected a valid IPv4 addresss.")
            raise e

        # download the raw text logs
        f = io.StringIO()
        with redirect_stderr(f):
            self.download(targetIP)

        # convert to JSON
        if HV_FNAME in dict(self.txtFiles):
            jsonFmt = self.logFileToJSON(HV_FNAME)
            self.events.append(tuple(asdict(x) for x in jsonFmt))
            self.txtFiles.remove((HV_FNAME, 0))

        i = 1
        for vmLogFile in self.txtFiles:
            jsonFmt = self.logFileToJSON(vmLogFile[0], i)
            self.events.append(tuple(asdict(x) for x in jsonFmt))
            i += 1
        
        outputFileName = ''
        if i > 0:
            # write to file
            trace_file_data = {
                    "traceEvents": list(sum(self.events, ()))
                    }

            outputFileName = OUT_FNAME + ".json"
            f = open(outputFileName, "w")
            f.write(json.dumps(trace_file_data, indent=2))
            f.close

        # return the output file name and number of boot log files parsed
        return outputFileName, i

#Helpers

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

def main():
    TraceFile = VxBootTF()
    fname, count = TraceFile.getLogs('128.224.86.181')

    if count > 0:
        print("\n%d log file(s) written to %s\n" % (count, fname))


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print ("\nFailed to read boot log file from target.\n" + str(e))
        import traceback
        traceback.print_exc()
