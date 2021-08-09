inherit packagegroup

SRCNAME = "packagegroup-monitoring"

PROVIDES = "virtual/monitoring"

PACKAGES = "\
	${SRCNAME}-core \
	${SRCNAME}-agent \
	${SRCNAME}-proxy \
"

RDEPENDS:${SRCNAME}-core = ""
RDEPENDS:${SRCNAME}-agent = ""
RDEPENDS:${SRCNAME}-proxy = ""
