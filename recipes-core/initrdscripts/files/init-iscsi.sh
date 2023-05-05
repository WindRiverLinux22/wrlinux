#!/bin/sh
# This is the init script for iSCSI boot.

read_args() {
    [ -z "$CMDLINE" ] && CMDLINE=`cat /proc/cmdline`
    for arg in $CMDLINE; do
        optarg=`expr "x$arg" : 'x[^=]*=\(.*\)'`
        case $arg in
            realroot_index=*)
                    realroot_index=$optarg ;;
            initiator_name=*)
                initiator_name=$optarg ;;
            iscsi_target_ip=*)
                iscsi_target_ip=$optarg ;;
            iscsi_target_name=*)
                iscsi_target_name=$optarg
        esac
    done
}

connect_iscsi_target() {
    # Contact iSCSI target
    echo "InitiatorName=$initiator_name" > /etc/iscsi/initiatorname.iscsi && \
    iscsid && \
    iscsiadm --mode discovery --type sendtargets --portal $iscsi_target_ip --discover && \
    iscsiadm --mode node --targetname $iscsi_target_name --login
}

read_args

connect_iscsi_target

if [ $? -eq 0 ]; then
    exit 0
else
    echo "Error: cannot connect iSCSI target!"
    exit 1
fi
