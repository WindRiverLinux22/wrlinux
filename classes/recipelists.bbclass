# Class that allows you to restrict the recipes brought from a layer to
# a specified list. This is similar in operation to blocklist.bbclass
# but note the difference in how *_RECIPES is set - we don't use varflags
# here, the recipe name goes in the value and we use an override for the
# layer name (although this is not strictly required - you can have one
# *_RECIPES value shared by all of the layers specified in
# RECIPE_LIST_LAYERS). The layer name used here is actually the name that
# gets added to BBFILE_COLLECTIONS in the layer's layer.conf, which may
# differ from how the layer is otherwise known - e.g. meta-oe uses
# "openembedded-layer".
#
# INHERIT += "recipelists"
# RECIPE_LIST_LAYERS = "layername"
# For Core WRL Recipes:
# WRL_RECIPES:<layername> = "recipe1 recipe2"
# For recipes in CCM Generated Layers:
# CCM_RECIPES:<ccm_layername> = "recipe1 recipe2"
# For recipes in Layers that a customer creates
# CUSTOMER_RECIPES:<customer_layername> = "recipe1 recipe2"
#
# If you would prefer to set a reason message other than the default, you
# can do so:
#
# RECIPE_LIST_REASON:layername = "not supported by ${DISTRO}"

# Generic reason
RECIPE_LIST_KEY_MSG ?= "To override, add to your local.conf:"
RECIPE_LIST_CURRENT_LAYER ?= "${@bb.utils.get_file_layer(d.getVar('FILE'), d)}"
RECIPE_LIST_REASON ?= "Not supported in this configuration by Wind River. ${RECIPE_LIST_KEY_MSG} CUSTOMER_RECIPES:${RECIPE_LIST_CURRENT_LAYER} += '${BPN}'"
RECIPE_LIST_REASON_ADDON ?= "You may also have to add: BB_NO_NETWORK = '0'"

python() {
    from pathlib import Path

    layer = bb.utils.get_file_layer(d.getVar('FILE'), d)
    if layer:
        cache_dir = d.getVar('CACHE')

        layers = (d.getVar('RECIPE_LIST_LAYERS') or '').split()
        if d.getVar('PNWHITELIST_LAYERS') is not None:
            layers = layers + (d.getVar('PNWHITELIST_LAYERS') or '').split()
            bb.warnonce("PNWHITELIST_LAYERS is deprecated please use RECIPE_LIST_LAYERS")
        if layer in layers:
            machine = d.getVar('MACHINE') or ''
            localdata = bb.data.createCopy(d)
            localdata.setVar('OVERRIDES', layer + ':' + machine)
            recipes = (localdata.getVar('WRL_RECIPES') or '').split()
            recipes = recipes + (localdata.getVar('CCM_RECIPES') or '').split()
            recipes = recipes + (localdata.getVar('CUSTOMER_RECIPES') or '').split()
            if localdata.getVar('PNWHITELIST') is not None:
                recipes = recipes + (localdata.getVar('PNWHITELIST') or '').split()
                bb.warnonce("PNWHITELIST is deprecated please use CUSTOMER_RECIPES")
            if not (d.getVar('PN') in recipes or d.getVar('BPN') in recipes):
                reason = localdata.getVar('RECIPE_LIST_REASON')
                if localdata.getVar('PNWHITELIST_REASON') is not None:
                    reason = localdata.getVar('PNWHITELIST_REASON')
                    bb.warnonce("PNWHITELIST_REASON is deprecated please use RECIPE_LIST_REASON")
                if not reason:
                    reason = 'not in recipe list for layer %s' % layer
                raise bb.parse.SkipRecipe(reason)
}

python recipelist_noprovider_handler() {
    import subprocess

    saved_distro_features = e.data.getVar('DISTRO_FEATURES')

    key_msg = d.getVar('RECIPE_LIST_KEY_MSG')
    reason = str(e)
    if not key_msg in reason:
        return

    pn = e.getItem()
    bb.warn('%s is not in the recipe list, figuring out complete list of recipes...' % pn)

    cache_dir = d.getVar('CACHE')
    cache_file = os.path.join(cache_dir, 'bb_cache.dat')
    dump_cache_tool = os.path.join(d.getVar('COREBASE'), 'bitbake/contrib/dump_cache.py')
    cmd = [dump_cache_tool, '-m', 'pn,packages,provides,rprovides,appends,skipped,skipreason', cache_file]

    try:
        dumped_result = subprocess.check_output(cmd, stderr=subprocess.STDOUT).decode('utf-8')
    except subprocess.CalledProcessError as exec:
        bb.warn('%s' % exec)
        bb.warn('%s' % exec.output.decode('utf-8'))
        return

    def dump_cache(pn):
        bbfile = ''
        appends = ''
        skipped = ''
        skipreason = ''

        # Try to find the one which is in recipes.
        for line in dumped_result.split('\n'):
            if not (line and '.bb' in line):
                continue

            line_list = line.split(': ')

            saved_pn = line_list[1]
            packages = eval(line_list[2])
            provides = eval(line_list[3])
            rprovides = eval(line_list[4])
            if not pn in ([saved_pn] + provides + rprovides + packages):
                continue

            bbfile = line_list[0]
            appends = eval(line_list[5])
            skipped = eval(line_list[6])
            skipreason = ': '.join(line_list[7:]).strip()
            if not skipped:
                break

        return bbfile, appends, skipped, skipreason

    def get_depends(bbfile, d):
        depends = ''
        if bbfile:
            localdata = bb.data.createCopy(d)
            bbfile = bb.cache.virtualfn2realfn(bbfile)[0]
            # Override DISTRO_FEATURES_NATIVE and DISTRO_FEATURES_NATIVESDK
            # since virtualfn2realfn is called.
            localdata.setVar('DISTRO_FEATURES', saved_distro_features)
            bb.cache.parse_recipe(localdata, bbfile, appends)
            bb.data.expandKeys(localdata)
            depends = localdata.getVar('DEPENDS')
            packages = localdata.getVar('PACKAGES')
            for pkg in packages.split():
                rdep_pkgs = localdata.getVar('RDEPENDS:%s' % pkg) or ''
                if rdep_pkgs:
                    depends += ' ' + rdep_pkgs

                rrec_pkgs = localdata.getVar('RRECOMMENDS:%s' % pkg) or ''
                if rrec_pkgs:
                    depends += ' ' + rrec_pkgs

            # Handle PACKAGECONFIG
            pkgconfigflags = localdata.getVarFlags("PACKAGECONFIG") or {}
            if pkgconfigflags:
                pkgconfig = (localdata.getVar('PACKAGECONFIG') or "").split()
                for flag, flagval in sorted(pkgconfigflags.items()):
                    items = flagval.split(",")
                    num = len(items)
                    if flag in pkgconfig:
                        if num >= 3 and items[2]:
                            depends += ' ' + items[2]
                        if num >= 4 and items[3]:
                            depends += ' ' + items[3]
                        if num >= 5 and items[4]:
                            depends += ' ' + items[4]

            # Handle Inter-Task Dependencies
            tasks = filter(lambda k: localdata.getVarFlag(k, "task"), d.keys())
            for task in tasks:
                taskVar = localdata.getVarFlags(task, False)
                if 'depends' in taskVar and ':' in taskVar["depends"]:
                    items = taskVar["depends"].split(':')[0]
                    if '${PV}' in items:
                        items = items.replace('${PV}', localdata.getVar('PV'))
                    depends += ' ' + items
        else:
            bb.warn('bbfile is empty')

        return ' '.join(bb.utils.explode_deps(depends))

    def get_templates(support_detail):
        pw_template = []
        if support_detail and '#' in support_detail:
            supported = support_detail.split("#")[0].strip()
            if supported and supported == '1':
                pw_template += support_detail.split("#")[1].strip().split()
        return pw_template

    # This is only a helper, so catch all possible errors, don't break
    # anything when there are unexpected errors.
    try:
        bbfile, appends, skipped, skipreason = dump_cache(pn)
        depends = get_depends(bbfile, d)

        add_lines = []
        pw_templates = []
        support_detail = d.getVar('WRLINUX_SUPPORTED_RECIPE:pn-%s' % pn)
        pw_templates += get_templates(support_detail)
        checked = set(d.getVar('ASSUME_PROVIDED').split())
        next = set(depends.split())
        counter = 0
        while next:
            if counter > 100:
                # Something must be wrong, just break out
                bb.error("Too many loops when calculating recipe list!")
                break
            new = set()
            for dep in next:
                if dep in checked:
                    continue
                checked.add(dep)
                bbfile, appends, skipped, skipreason = dump_cache(dep)
                if skipped and key_msg in skipreason:
                    add_line = skipreason.split(key_msg)[1].strip()
                    if not add_line in add_lines:
                        add_lines.append(add_line)
                    new.add(dep)
                    depends = get_depends(bbfile, d)
                    if depends:
                        new |= set(depends.split())
            new -= checked
            next = new
            counter += 1

        e_reasons = set(e._reasons)
        msg_prefix = ' '.join(e_reasons).split('%s ' % key_msg)[0] + key_msg
        msg_suffix = ' '.join(e_reasons).split('%s ' % key_msg)[1]
        if not msg_suffix in add_lines:
            add_lines.append(msg_suffix)
        add_lines.sort()
        pw_templates.sort()
        addon = d.getVar('RECIPE_LIST_REASON_ADDON')
        if addon:
            add_lines.append('\n%s' % addon)
        if pw_templates:
            template_message = "\nOr consider using one of the following template(s):"
            for temp in pw_templates:
                template_message += "\nWRTEMPLATE += \"%s\"" % temp
            e._reasons = [msg_prefix] + add_lines + [template_message]
        else:
            e._reasons = [msg_prefix] + add_lines
    except Exception as esc:
        bb.error('recipelist_noprovider_handler() failed: %s' % esc)
}

addhandler recipelist_noprovider_handler
recipelist_noprovider_handler[eventmask] = "bb.event.NoProvider"
