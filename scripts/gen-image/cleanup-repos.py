#!/usr/bin/env python3
#
# Copyright (C) 2023 Wind River Systems, Inc.
#
# SPDX-License-Identifier: GPL-2.0
#
# Remove old rpm packages when there are multiple ones, only keep the latest
# one
#

import os
import sys
import glob
import subprocess
import multiprocessing

if len(sys.argv) != 3:
    print('Usage: %s /path/to/rpm_cmd /path/to/deploy/rpm\n' % sys.argv[0])
    sys.exit(1)

rpm_bin = sys.argv[1]
rpm_dir = sys.argv[2]
rpm_cmd = rpm_bin + " --dbpath=/tmp/ -qp --qf='%{name}'"

def run_cmd(cmd, rpm):
    name = subprocess.run(cmd, capture_output=True, shell=True, timeout=120)
    return (name, rpm)

print('Getting all rpms...')

# The format is name:[rpm1, rpm2, ...]
rpms_dict = {}

path_spec = "%s/*/*.rpm" % rpm_dir
all_rpms = sorted(glob.glob(path_spec))

pool = multiprocessing.Pool(processes=int(multiprocessing.cpu_count()/2))
results = []
for rpm in all_rpms:
    if not rpm.endswith('.rpm'):
        continue
    cmd = '%s %s' % (rpm_cmd, rpm)
    results.append(pool.apply_async(run_cmd, (cmd, rpm,)))

pool.close()
pool.join()

print('Cleanup multiple version rpms...')
for name_rpm in results:
    name = name_rpm.get()[0].stdout.decode('utf-8')
    rpm = name_rpm.get()[1]
    if name in rpms_dict:
        rpms_dict[name].append(rpm)
    else:
        rpms_dict[name] = [rpm]

for name, rpms in rpms_dict.items():
    if len(rpms) > 1:
        rpms = sorted(rpms, key=os.path.getmtime)
        for fn in rpms[:-1]:
            if fn and os.path.exists(fn):
                print('Removing old rpm: %s' % fn)
                os.remove(fn)
