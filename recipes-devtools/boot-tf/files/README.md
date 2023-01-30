# boot-tf

This tool parses and converts HVP (hypervisor & VxWorks) and WRLinux boot logs
into the JSON based Google Trace Event format. The resultant JSON files can
be visualized using Google Trace Viewer, which is available as a standalone
FOSS or built-in to any Chromium based browser (ex. Chrome, Edge).

To open in a browser, type "chrome://tracing" into the address bar.

<br/>

## Downloading boot data from VxWorks

To download boot data from VxWorks, the VxWorks instance (guest or native)
must be configured with the TFTP server component with the TFTPS_DIRS working
directory set to a valid file-system folder. This may require the inclusion of a
RAM disk or SD card driver or similar to host the file system.

If multiple VxWorks guests exist in the system, only 1 of them requires the
TFTP server. This guest will automatically collect the logs from the other
VxWorks guests via shared memory.

To download the boot data from VxWorks, use the following command:

`boot-tf -v [IP address of target] -o [output dir]`

or

`boot-tf -l [IP address of target] -o [output dir]`

**Note:** the -o argument is optional

In the case of an HVP system with only VxWorks guests, the above 2 commands are
effectively identical. These commands diverge primarly where Linux guests are
involved.

<br/>

## Downloading boot data from WRLinux

In WRLinux-LTS-22 boot-tf is incorporated under recipes-devtools in the wrlinux
layer. The script is configured to run automatically upon completion of the
Linux guest initialization. Its job within the Linux guest context is to:

- parse and convert the linux bootchart data into JSON
- download and convert the hypervisor and VxWorks logs from the main VxWorks guest
- merge all system logs into a single JSON file
- copy the final merged system log data back to the main VxWorks guest (or optionally to a host machine)

In order for the Linux guest to be able to communicate with the main VxWorks guest,
the following definitions need to exist in local.conf:

`BOOT_TF_VX_DOWNLOAD = "-v 10.0.0.2"`

`BOOT_TF_UPLOAD      = "-u 10.0.0.2"`

The address provided must be an IPv4 address through which the VxWorks guest
is acccessible. In the example above, this is a VNIC address given to the
VxWorks guest in its BootLine by the hypervisor xmlconfig.

To download the complete set of system boot information from either the Linux
guest or a VxWorks guest which has received the data from a Linux guest, use
the following command:

`boot-tf -l [IP address of target] -o [output dir]`

**Note 1:** the -v option would return only HV and VxWorks boot information, which
is why -l must be used where 1 or more Linux guests exist.

**Note 2:** alternately, the BOOT_TF_UPLOAD argument string can be set to pass the
address of a host machine, allowing the guest to automatically upload all boot data
to the host, provided it has an active TFTP server.

<br/>

## Understanding output files

After executing boot-tf, a common set of files will be downloaded depending on
the number and type of guest OS instances in the system.

| Filename | Description | Applicability |
| ----------- | ----------- | ----------- |
| boot-tf.manifest | Listing of all downloaded files | HVP, VxWorks Native, WRLinux |
| hv_bootlog | Hypervisor boot log output in human-readable text format | HVP Only |
| vx_bootlog# | VxWorks boot log output in text format, where # is the VM ID associated with the guest | HVP and VxWorks Native<sup>1</sup>  |
| VxBootTF.json | Hypervisor and VxWorks combined boot sequence in Google Trace Event format | HVP and VxWorks Native<sup>2</sup> |
| bootchart-YYYYMMDD-HHMM.json | Linux guest bootchart converted into Google Trace Event format | WRLinux |
| merged-boot-tf-YYYYMMDD-HHMM.json | Complete system boot data for all components (HV, VxWorks, Linux) in Google Trace Event format | HVP |

1. In VxWorks native, no VM ID exists, so the filename will not be suffixed (will just be 'vx_bootlog')
2. In VxWorks native, the VxBootTF.json file will be equivalent to just the one set of VxWorks boot logs converted into Google Trace Event format
