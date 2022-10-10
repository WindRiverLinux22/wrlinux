# This file is generated automatically by wry
CHRONY_INC_WRLINUX = ""
CHRONY_INC_WRLINUX:osv-wrlinux = "${@'chrony_wrlinux.inc' if d.getVar('CUSTOM_NTP_SERVER') else ''}"
require ${CHRONY_INC_WRLINUX}
