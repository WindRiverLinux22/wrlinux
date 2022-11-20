# Class to avoid copying packages into the feed if they haven't materially changed
#
# Copyright (C) 2015 Intel Corporation
# Released under the MIT license (see COPYING.MIT for details)
#
# This class effectively intercepts packages as they are written out by
# do_package_write_*, causing them to be written into a different
# directory where we can compare them to whatever older packages might
# be in the "real" package feed directory, and avoid copying the new
# package to the feed if it has not materially changed. The idea is to
# avoid unnecessary churn in the packages when dependencies trigger task
# reexecution (and thus repackaging). Enabling the class is simple:
#
# INHERIT += "packagefeed-stability"
#
# Caveats:
# 1) Latest PR values in the build system may not match those in packages
#    seen on the target (naturally)
# 2) If you rebuild from sstate without the existing package feed present,
#    you will lose the "state" of the package feed i.e. the preserved old
#    package versions. Not the end of the world, but would negate the
#    entire purpose of this class.
#
# Note that running -c cleanall on a recipe will purposely delete the old
# package files so they will definitely be copied the next time.

# Skip comparing if PE, PV and PR are the same when set to 1
PACKAGE_COMPARE_FAST ?= "0"

python() {
    if bb.data.inherits_class('native', d) or bb.data.inherits_class('cross', d):
        return
    # Package backend agnostic intercept
    # This assumes that the package_write task is called package_write_<pkgtype>
    # and that the directory in which packages should be written is
    # pointed to by the variable DEPLOY_DIR_<PKGTYPE>
    for pkgclass in (d.getVar('PACKAGE_CLASSES') or '').split():
        if pkgclass.startswith('package_'):
            pkgtype = pkgclass.split('_', 1)[1]
            pkgwritefunc = 'do_package_write_%s' % pkgtype
            sstate_outputdirs = d.getVarFlag(pkgwritefunc, 'sstate-outputdirs', False)
            deploydirvar = 'DEPLOY_DIR_%s' % pkgtype.upper()
            deploydirvarref = '${' + deploydirvar + '}'
            pkgcomparefunc = 'do_package_compare_%s' % pkgtype

            if bb.data.inherits_class('image', d):
                d.appendVarFlag('do_rootfs', 'recrdeptask', ' ' + pkgcomparefunc)

            if bb.data.inherits_class('populate_sdk_base', d):
                d.appendVarFlag('do_populate_sdk', 'recrdeptask', ' ' + pkgcomparefunc)

            if bb.data.inherits_class('populate_sdk_ext', d):
                d.appendVarFlag('do_populate_sdk_ext', 'recrdeptask', ' ' + pkgcomparefunc)

            d.appendVarFlag('do_build', 'recrdeptask', ' ' + pkgcomparefunc)

            if bb.data.inherits_class('nopackages', d) or d.getVarFlag(pkgwritefunc, 'noexec') or \
                not d.getVarFlag(pkgwritefunc, 'task'):
                # Packaging is disabled for this recipe, we shouldn't do anything
                continue

            if deploydirvarref in sstate_outputdirs:
                deplor_dir_pkgtype = d.expand(deploydirvarref + '-prediff')
                # Set intermediate output directory
                d.setVarFlag(pkgwritefunc, 'sstate-outputdirs', sstate_outputdirs.replace(deploydirvarref, deplor_dir_pkgtype))
                # Update SSTATE_ALLOW_OVERLAP_FILES to avoid shared location conflicted error
                d.appendVar('SSTATE_ALLOW_OVERLAP_FILES', ' %s' % deplor_dir_pkgtype)

            d.setVar(pkgcomparefunc, d.getVar('do_package_compare', False))
            d.setVarFlags(pkgcomparefunc, d.getVarFlags('do_package_compare', False))
            d.appendVarFlag(pkgcomparefunc, 'depends', ' build-compare-native:do_populate_sysroot')
            # Target recipe uses gcc-cross' objdump, but nativesdk uses host's objdump
            if (not bb.utils.to_boolean(d.getVar('INHIBIT_DEFAULT_DEPS'))) and \
                    (not bb.data.inherits_class('nativesdk', d)):
                target_arch = d.getVar('TARGET_ARCH')
                d.appendVarFlag(pkgcomparefunc, 'depends', ' gcc-cross-%s:do_populate_sysroot' % target_arch)
            bb.build.addtask(pkgcomparefunc, 'do_build', 'do_packagedata ' + pkgwritefunc, d)
}

# This isn't the real task function - it's a template that we use in the
# anonymous python code above
fakeroot python do_package_compare () {
    currenttask = d.getVar('BB_CURRENTTASK')
    pkgtype = currenttask.rsplit('_', 1)[1]
    package_compare_impl(pkgtype, d)
}

def package_compare_impl(pkgtype, d):
    import errno
    import fnmatch
    import glob
    import subprocess
    import oe.sstatesig

    pn = d.getVar('PN')
    deploydir = d.getVar('DEPLOY_DIR_%s' % pkgtype.upper())
    prepath = deploydir + '-prediff/'

    pkgwritetask = 'package_write_%s' % pkgtype
    manifest, _ = oe.sstatesig.sstate_get_manifest_filename(pkgwritetask, d)

    # Skip comparing if PE, PV and PR are the same
    skip = True
    if bb.utils.to_boolean(d.getVar('PACKAGE_COMPARE_FAST')):
        with open(manifest, 'r') as f:
            for line in f.readlines():
                bn = os.path.basename(line.strip())
                line_new = os.path.join(deploydir, bn)
                if not os.path.exists(line_new):
                    skip = False
                    break
    if skip:
        bb.note("Skipping package comparing since all packages' PE, PV and PR are the same")
        return

    # Find out PKGR values are
    pkgdatadir = d.getVar('PKGDATA_DIR')
    packages = []
    try:
        with open(os.path.join(pkgdatadir, pn), 'r') as f:
            for line in f:
                if line.startswith('PACKAGES:'):
                    packages = line.split(':', 1)[1].split()
                    break
    except IOError as e:
        if e.errno == errno.ENOENT:
            pass

    if not packages:
        bb.debug(2, '%s: no packages, nothing to do' % pn)
        return

    pkgrvalues = {}
    rpkgnames = {}
    rdepends = {}
    pkgvvalues = {}
    for pkg in packages:
        with open(os.path.join(pkgdatadir, 'runtime', pkg), 'r') as f:
            for line in f:
                if line.startswith('PKGR:'):
                    pkgrvalues[pkg] = line.split(':', 1)[1].strip()
                if line.startswith('PKGV:'):
                    pkgvvalues[pkg] = line.split(':', 1)[1].strip()
                elif line.startswith('PKG:%s:' % pkg):
                    rpkgnames[pkg] = line.split(':')[2].strip()
                elif line.startswith('RDEPENDS:%s:' % pkg):
                    rdepends[pkg] = line.split(':', 1)[1].strip()

    # Prepare a list of the runtime package names for packages that were
    # actually produced
    rpkglist = []
    for pkg, rpkg in rpkgnames.items():
        if os.path.exists(os.path.join(pkgdatadir, 'runtime', pkg + '.packaged')):
            rpkglist.append((rpkg, pkg))
    rpkglist.sort(key=lambda x: len(x[0]), reverse=True)

    pvu = d.getVar('PV', False)
    if '$' + '{SRCPV}' in pvu:
        pvprefix = pvu.split('$' + '{SRCPV}', 1)[0]
        # Expand Var such as LINUX_VERSION
        d.setVar('PACKAGE_COMPARE_PVPREFIX', pvprefix)
        pvprefix = d.getVar('PACKAGE_COMPARE_PVPREFIX')
    else:
        pvprefix = None

    files = []
    docopy = False
    mlprefix = d.getVar('MLPREFIX')
    pcmanifest = os.path.join(prepath, d.expand('pkg-compare-manifest-${MULTIMACH_TARGET_SYS}-${PN}'))
    pcmanifest_oldlines = []
    if os.path.exists(pcmanifest):
        with open(pcmanifest, 'r') as f:
            pcmanifest_oldlines = f.readlines()
    # Copy recipe's all packages if one of the packages are different to make
    # they have the same PR.
    with open(manifest, 'r') as f:
        for line in f:
            if line.startswith(prepath):
                srcpath = line.rstrip()
                if os.path.isfile(srcpath):
                    destpath = os.path.join(deploydir, os.path.relpath(srcpath, prepath))

                    # This is crude but should work assuming the output
                    # package file name starts with the package name
                    # and rpkglist is sorted by length (descending)
                    pkgbasename = os.path.basename(destpath)
                    pkgname = None
                    for rpkg, pkg in rpkglist:
                        if mlprefix and pkgtype == 'rpm' and rpkg.startswith(mlprefix):
                            rpkg = rpkg[len(mlprefix):]
                        if pkgbasename.startswith(rpkg):
                            pkgr = pkgrvalues[pkg]
                            destpathspec = destpath.replace(pkgr, '*')
                            if pvprefix:
                                pkgv = pkgvvalues[pkg]
                                if pkgv.startswith(pvprefix):
                                    destpathspec = destpathspec.replace(pkgv, pvprefix + "*")
                            pkgname = pkg
                            break
                    else:
                        bb.warn('Unable to map %s back to package' % pkgbasename)
                        destpathspec = destpath

                    oldfile = None
                    oldfiles = glob.glob(destpathspec)
                    if oldfiles:
                        oldfile = oldfiles[-1]
                        # Save old packages for removing in case this is a
                        # fresh build with old packges
                        for oldline in oldfiles:
                            oldline = '%s\n' % oldfile
                            if not oldline in pcmanifest_oldlines:
                                with open(pcmanifest, 'a') as f:
                                    f.write(oldline)
                    if not docopy:
                        if oldfile:
                            result = subprocess.call(['env', 'PSEUDO_DISABLED=1', 'pkg-diff.sh', oldfile, srcpath])
                            if result != 0:
                                docopy = True
                                bb.note("%s and %s are different, will copy packages" % (oldfile, srcpath))
                        else:
                            docopy = True
                            bb.note("No old packages found for %s, will copy packages" % pkgname)

                    files.append((pkgname, pkgbasename, srcpath, destpath))

    # Remove all the old files and copy again if docopy
    if docopy:
        bb.note('Copying packages for recipe %s' % pn)
        try:
            with open(pcmanifest, 'r') as f:
                for line in f:
                    fn = line.rstrip()
                    if fn and os.path.exists(fn):
                        os.remove(fn)
                        bb.note('Removed old package %s' % fn)
        except IOError as e:
            if e.errno == errno.ENOENT:
                pass

        # Create new manifest
        with open(pcmanifest, 'w') as f:
            for pkgname, pkgbasename, srcpath, destpath in files:
                destdir = os.path.dirname(destpath)
                bb.utils.mkdirhier(destdir)
                # Remove allarch rpm pkg if it is already existed (for
                # multilib), they're identical in theory, but sstate.bbclass
                # copies it again, so keep align with that.
                if os.path.exists(destpath) and pkgtype == 'rpm' \
                        and d.getVar('PACKAGE_ARCH') == 'all':
                    os.unlink(destpath)
                if (os.stat(srcpath).st_dev == os.stat(destdir).st_dev):
                    # Remove destpath in case it exists
                    if os.path.exists(destpath):
                        bb.note('Removing %s' % destpath)
                        os.unlink(destpath)
                    # Use a hard link to save space
                    os.link(srcpath, destpath)
                else:
                    shutil.copyfile(srcpath, destpath)
                f.write('%s\n' % destpath)
    else:
        # Remove pcmanifest if no package is copied
        if os.path.exists(pcmanifest):
            os.unlink(pcmanifest)
        bb.note('Not copying packages for recipe %s' % pn)

do_cleansstate[postfuncs] += "pfs_cleanpkgs"
python pfs_cleanpkgs () {
    import errno
    for pkgclass in (d.getVar('PACKAGE_CLASSES') or '').split():
        if pkgclass.startswith('package_'):
            pkgtype = pkgclass.split('_', 1)[1]
            deploydir = d.getVar('DEPLOY_DIR_%s' % pkgtype.upper())
            prepath = deploydir + '-prediff'
            pcmanifest = os.path.join(prepath, d.expand('pkg-compare-manifest-${MULTIMACH_TARGET_SYS}-${PN}'))
            try:
                with open(pcmanifest, 'r') as f:
                    for line in f:
                        fn = line.rstrip()
                        if fn:
                            try:
                                os.remove(fn)
                            except OSError as e:
                                if e.errno == errno.ENOENT:
                                    pass
                os.remove(pcmanifest)
            except IOError as e:
                if e.errno == errno.ENOENT:
                    pass
}
