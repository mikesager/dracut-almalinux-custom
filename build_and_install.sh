#!/bin/bash

# Personal use only.  Not usable by others unless you know what you're doing and have the pre-reqs installed.

set -ex

rpmdev-setuptree
rpmdev-spectool -gRa dracut.spec
rpmdev-spectool -lRa dracut.spec  | grep ^Patch | awk -F': ' '{ print $2 }' | xargs -r -I '{}' cp -fv '{}' ~/rpmbuild/SOURCES
\cp -fv *.txt ~/rpmbuild/SOURCES
\cp -fv dracut.spec ~/rpmbuild/SPECS
rpmbuild -ba ~/rpmbuild/SPECS/dracut.spec
find /root/rpmbuild/RPMS/ -iname '*.rpm' | grep -E '/dracut-([0-9]+|config-rescue|network|squash|tools)' | grep -v debuginfo | xargs -r -t dnf install -y
dnf versionlock list | grep '^dracut-' | xargs -r dnf versionlock delete
dnf repoquery --installed --qf '%{name}' 'dracut*' | xargs -n 1 -t dnf versionlock
