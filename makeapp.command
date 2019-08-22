#!/usr/bin/env bash
# created by DhinakG

# check for directory arg
if [ ! -z "$1" ]
then
	cd "$1"
	echo "Directory $1 specified"

else
	# no directory arg, use current directory
	cd "$(dirname "${BASH_SOURCE[0]}")"
	echo "No directory specific, using current directory"
fi

# unmount any already mounted base system
if [ -d "/Volumes/macOS Base System" ]
then
	diskutil unmount "macOS Base System"
fi
if [ -d "/Volumes/OS X Base System" ]
then
	diskutil unmount "OS X Base System"
fi

# mount Base System
hdiutil attach BaseSystem.dmg

# copy Install macOS .app
if [ -d "/Volumes/macOS Base System" ]
then
	cp -PR /Volumes/"macOS Base System"/Install\ *.app .
fi
if [ -d "/Volumes/OS X Base System" ]
then
	cp -PR /Volumes/"OS X Base System"/Install\ *.app .
fi

# unmount Base System
if [ -d "/Volumes/macOS Base System" ]
then
	diskutil unmount "macOS Base System"
fi
if [ -d "/Volumes/OS X Base System" ]
then
	diskutil unmount "OS X Base System"
fi


# find Install .app in current directory, required for following commands to work
# modified from https://www.insanelymac.com/forum/topic/338810-create-legit-copy-of-macos-from-apple-catalog/, thank you!
for file in *; do
        if [[ $file == *.app ]]; then
            let index=${#name_array[@]}
            name_array[$index]="${file##*/}"
        fi
    done
    loc=${name_array[0]}

# create SharedSupport dir for full Install .app
mkdir "${loc}/Contents/SharedSupport"

# move AppleDiagnostics, BaseSystem to SharedSupport
mv Apple* "${loc}/Contents/SharedSupport"
mv BaseSys* "${loc}/Contents/SharedSupport"
mv InstallESDDmg.pkg "${loc}/Contents/SharedSupport/InstallESD.dmg"

# copy InstallInfo
mv InstallInfo* "${loc}/Contents/SharedSupport"

# edit InstallInfo
plutil -remove "Payload Image Info.chunklistURL" "${loc}/Contents/SharedSupport/InstallInfo.plist"
plutil -remove "Payload Image Info.chunklistid" "${loc}/Contents/SharedSupport/InstallInfo.plist"
plutil -replace "Payload Image Info.id" -string "com.apple.dmg.InstallESD" "${loc}/Contents/SharedSupport/InstallInfo.plist"
plutil -replace "Payload Image Info.URL" -string "InstallESD.dmg" "${loc}/Contents/SharedSupport/InstallInfo.plist"

echo "Done."
