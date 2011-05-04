#!/bin/bash


## Build an elpa package for slime

VERSION=$(grep -E -o "[0-9]{4,4}-[0-9]{1,2}-[0-9]{1,2}" slime/ChangeLog | head -1 | sed -e "s/-//g" )
echo "SLIME version $VERSION"

dest="slime-$VERSION"

rm -rf "marmalade/$dest" "marmalade/slime"
find slime \( -name '*.el' -or -name 'ChangeLog' \) | cpio -pd marmalade

sed -i .bak \
    -e "/For a detailed/ i \\
;; Authors: Eric Marsden, Luke Gorrie, Helmut Eller, Tobias C. Rittweiler" \
    -e "/For a detailed/ i \\
;; URL: http://common-lisp.net/project/slime/" \
    -e "/For a detailed/ i \\
;; Keywords: languages, lisp, slime" \
    -e "/For a detailed/ i \\
;; Version: $VERSION" \
    -e "/For a detailed/ i \\
;; Adapted-by: Hugo Duncan" \
    -e "/For a detailed/ i \\
;;" \
    marmalade/slime/slime.el

rm marmalade/slime/slime.el.bak

cat > marmalade/slime/slime-pkg.el <<EOF
(define-package "slime" "$VERSION"
                "Superior Lisp Interaction Mode for Emacs")
EOF

mv marmalade/slime marmalade/$dest
( cd marmalade; tar cvf ../$dest.tar $dest )
ls -l $dest.tar