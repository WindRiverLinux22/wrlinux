

# With -O0 optimization we blow up linking/relocating.
#
DEBUG_OPTIMIZATION:append:powerpc = " -O1"
DEBUG_OPTIMIZATION:append:mips = " -O1"
DEBUG_OPTIMIZATION:append:aarch64 = " -O1"
# Blow up linking/relocating error.
PROFILING_OPTIMIZATION:remove:powerpc = "-fno-omit-frame-pointer"
PROFILING_OPTIMIZATION:remove:x86 = "-fno-omit-frame-pointer"
