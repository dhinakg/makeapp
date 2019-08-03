#!/usr/bin/env bash
# created by DhinakG

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
	cp -r /Volumes/"macOS Base System"/Install\ *.app .
fi
if [ -d "/Volumes/OS X Base System" ]
then
	cp -r /Volumes/"OS X Base System"/Install\ *.app .
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

# expand InstallESD package to get InstallESD
pkgutil --expand-full InstallESDDmg.pkg InstallESD/

# copy InstallESD to SharedSupport
mv InstallESD/InstallESD.dmg .
mv InstallESD.dmg "${loc}/Contents/SharedSupport"
mv InstallESDDmg.chunklist "${loc}/Contents/SharedSupport"

# copy InstallInfo
mv InstallInfo* "${loc}/Contents/SharedSupport"

echo Done
