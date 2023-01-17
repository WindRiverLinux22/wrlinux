"""
 bootlogConst.py - Boot Log Download and Parsing Constants
"""

"""
 Copyright (c) 2022 Wind River Systems, Inc.

 SPDX-License-Identifier: MIT
"""

#Hypervisor default constants
MOD_BSP             = 0x100
MOD_VMM_KERN        = 0x200
MOD_VMM_ARM_ARCH    = 0x300
MOD_HV_MGR          = 0x400
MOD_DB_MGR          = 0x500
MOD_SERVICES_MGR    = 0x600
MOD_HM_MGR          = 0x700
MOD_VM_MGR          = 0x800
MOD_CHCFG_MGR       = 0x900
MOD_VNIC_MGR        = 0xA00
MOD_SHMEM_MGR       = 0xB00
MOD_EMULATED_DEV    = 0xC00
MOD_HVMEM_MGR       = 0xD00
MOD_STARTUP_MGR     = 0xE00
MOD_NS_MGR          = 0xF00
MOD_CORE_MGR        = 0x1000
MOD_CTX_MGR         = 0x1100
MOD_ESH_MGR         = 0x1200
MOD_GDB_MGR         = 0x1300
MOD_PCI_MGR         = 0x1400
MOD_RTC_MGR         = 0x1500
MOD_THROTTLE_MGR    = 0x1600  

HV_MODS = dict([
(MOD_BSP,           "BSP/PSL"),
(MOD_VMM_KERN,      "VMM_Kernel"),
(MOD_VMM_ARM_ARCH,  "VMM_ARM_Arch"),
(MOD_HV_MGR,        "HV_Manager"),
(MOD_DB_MGR,        "DB_Manager"),
(MOD_SERVICES_MGR,  "Services_Manager"),
(MOD_HM_MGR,        "HM_Manager"),
(MOD_VM_MGR,        "VM_Manager"),
(MOD_CHCFG_MGR,     "VirtIO_Channel_Manager"),
(MOD_VNIC_MGR,      "VNIC_Manager"),
(MOD_SHMEM_MGR,     "Shared_Memory_Manager"),
(MOD_EMULATED_DEV,  "Emulated_Devices_Manager"),
(MOD_HVMEM_MGR,     "HV_Memory_Manger"),
(MOD_STARTUP_MGR,   "HV_Startup_Lib"),
(MOD_NS_MGR,        "Naming_Service"),
(MOD_CORE_MGR,      "Core_Manager"),
(MOD_CTX_MGR,       "Context_Manager"),  
(MOD_ESH_MGR,       "Shell_Manager"),
(MOD_GDB_MGR,       "GDB_Server_Manager"),
(MOD_PCI_MGR,       "PCI_Bus_Manager"),
(MOD_RTC_MGR,       "RealtimeClock_Manager"),
(MOD_THROTTLE_MGR,  "CPU_Throttle_Manager")
])

#VxWorks default constants
MOD_PRJCFG      = 0
MOD_ELD_LIB     = 1
MOD_ELD_DEV     = 2

VX_MODS = dict([
(MOD_PRJCFG,        "VIP_prjConfig"),
(MOD_ELD_LIB,       "earlyLogLib"),
(MOD_ELD_DEV,       "earlyLogLib_IOS_device")
])
