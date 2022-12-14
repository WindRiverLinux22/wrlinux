#! /bin/bash
#
# gen-linux-srcrev: Generate the SRCREV_machine entries for the
#                   linux-yocto recipe
#
#  Copyright (c) 2017 Wind River Systems, Inc.
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2 as
#  published by the Free Software Foundation.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#  See the GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# Run this script from the wr-kernel/git directory.

# Set the following when a specific version is supported.

gen_kernel_rev()
{
	local version=$1
	local prefix=""

	echo
	echo "# linux-yocto-${version} entries"
	echo
	echo "# linux-yocto-${version} branch entries"
	(
		if [ -d linux-yocto-${version} ]; then
			cd linux-yocto-${version}
		elif [ -d linux-yocto-${version}.git ]; then
			cd linux-yocto-${version}.git
		elif [ -d linux-yocto ]; then
			cd linux-yocto
		elif [ -d linux-yocto.git ]; then
			cd linux-yocto.git
		else
			echo "Unable to find linux-yocto-${version} or linux-yocto repository." >&2
			exit 1
		fi

		[ "$version" = "dev" ] && prefix="dev-"

		for branch in `git for-each-ref --format='%(refname)' refs/heads` ; do
			# Skip any branch with 'rebase' in the name, these are only useful
			# for bisecting and should not be used by BSPs.
			if [ ${branch/rebase//} != ${branch} ]; then
				continue
			fi

			VERSION=$(git show $branch:Makefile | grep "^VERSION =" | sed s/.*=\ *//)
			PATCHLEVEL=$(git show $branch:Makefile | grep "^PATCHLEVEL =" | sed s/.*=\ *//)
			SUBLEVEL=$(git show $branch:Makefile | grep "^SUBLEVEL =" | sed s/.*=\ *//)
			EXTRAVERSION=$(git show $branch:Makefile | grep "^EXTRAVERSION =" | sed s/.*=\ *//)

			# Build a plain version string
			kver="${VERSION}.${PATCHLEVEL}"
			if [ -n "${SUBLEVEL}" ]; then
				# Ignoring a SUBLEVEL of zero is fine
				if [ "${SUBLEVEL}" != "0" ]; then
					kver="${kver}.${SUBLEVEL}"
				fi
			fi
			kver="${kver}${EXTRAVERSION}"

			echo SRCREV_machine:kb-${prefix}$(echo $branch | sed 's,refs/heads/,,' | sed 's,/,-,g') ?= \"$(git rev-parse $branch)\"
			echo LINUX_VERSION:kb-${prefix}$(echo $branch | sed 's,refs/heads/,,' | sed 's,/,-,g') = \"${kver}\"
		done
	)
}

gen_meta_rev()
{
	local version=$1
	echo
	echo "# yocto-kernel-cache entries"
	(
		if [ -d yocto-kernel-cache ]; then
			cd yocto-kernel-cache
		elif [ -d yocto-kernel-cache.git ]; then
			cd yocto-kernel-cache.git
		else
			echo "Unable to find yocto-kernel-cache repository." >&2
			exit 1
		fi

		refs=`git for-each-ref --format='%(refname)' refs/heads`
		for branch in $refs ; do
			base_branch=$(echo $branch | sed 's,refs/heads/,,')
			if [[ $refs =~ "${base_branch}-wr" ]]; then
				# We need the one with "-wr" if it exists
				continue
			fi
			base_version=$(echo $base_branch | sed 's,yocto-,,' | sed 's,-wr,,')
			if [[ "${base_version}" = "${version}" ]]; then
				echo KERNEL_CACHE_BRANCH_${base_version} = \"${base_branch}\"
				echo SRCREV_meta_${base_version} = \"$(git rev-parse ${base_branch})\"
			fi
			if [[ "$version" = "dev" && "$base_version" = "master" ]]; then
				echo KERNEL_CACHE_BRANCH_${version} = \"${base_branch}\"
				echo SRCREV_meta_${version} = \"$(git rev-parse ${base_branch})\"
			fi
		done
	)
}


vers="$*"
echo "#"
echo "# This file is generated based on:"
for version in $vers; do
	echo "#     linux-yocto-${version}"
done
echo "#     yocto-kernel-cache"
echo "#"
echo "# Any manual changes will be overwritten."
echo "#"
echo "# This will cause SRCREV_machine:kb-<KBRANCH> take priority over SRCREV_machine:<machine>"
echo "MACHINEOVERRIDES .= \":kb-\${@oe.utils.conditional('PREFERRED_PROVIDER_virtual/kernel', 'linux-yocto-dev', 'dev-', '', d)}\${@d.getVar('KBRANCH', True).replace(\"/\", \"-\")}\""

for version in $vers; do
	gen_kernel_rev $version
	gen_meta_rev $version
done
