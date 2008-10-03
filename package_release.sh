#!/bin/sh
# This script is heavily based on ShakesPeers mkdmg by Martin Hedenfalk et al.

die()
{
    message=$1
    echo "$message"
    test -n "$MYDEV" && hdiutil eject $MYDEV
    /bin/rm -f $TMPDMG
    exit 1
}


if [[ -z $1 ]]; then
   die "Please specify how the release should be named"
fi


OUTPUT_DIR=build
RELEAS_PANE='build/Release/ipfwPane.prefPane'

TMPDMG=build/tmp.dmg
/bin/rm -f $TMPDMG


test -d "$RELEAS_PANE" || die "Found no .prefPane in Release"


VOL=ipfwPane-$1
echo "Creating disk image $VOL"

# clean up if we're interrupted
trap 'rm -f $TMPDMG; exit 1' 2 3 15

# create a disk image
hdiutil create -megabytes 5 $TMPDMG -layout NONE
# associate a device with this but don't mount it
MYDEV=`hdid -nomount $TMPDMG`
test -n "$MYDEV" || die "Failed to attach disk image"
# create a file system
newfs_hfs -v "$VOL" $MYDEV || die "Failed to create file system"
# diassociate device
hdiutil eject $MYDEV
# mount it
hdid $TMPDMG || die "Failed to mount disk image"


VOL_ROOT="/Volumes/$VOL"


echo "+ Copying ipfwPane.prefPane"
/bin/cp -R "$RELEAS_PANE" "$VOL_ROOT"


echo "+ Copying license"
/bin/cp "BSD License.txt" "$VOL_ROOT"


rm -f "$OUTPUT_DIR/$VOL.dmg"


# eject
hdiutil eject $MYDEV
# compress it and make it read only
hdiutil convert -format UDZO $TMPDMG -o "$OUTPUT_DIR/$VOL.dmg"
/bin/rm -f $TMPDMG
ls -lh "$OUTPUT_DIR/$VOL.dmg"
