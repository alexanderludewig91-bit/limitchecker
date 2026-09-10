#!/bin/zsh
set -euo pipefail

if [[ $# -ne 1 ]]; then
  print -u2 "Usage: $0 <version>"
  exit 64
fi

project_root=${0:A:h:h}
version="$1"
app_path="$project_root/dist/LimitChecker.app"
dmg_path="$project_root/dist/LimitChecker-$version-macos-universal.dmg"
work_directory=$(mktemp -d)
staging_directory="$work_directory/staging"
rw_dmg_path="$work_directory/LimitChecker-rw.dmg"
device=""

cleanup() {
  if [[ -n "$device" ]]; then
    hdiutil detach "$device" -force >/dev/null 2>&1 || true
  fi
  rm -rf "$work_directory"
}
trap cleanup EXIT

if [[ ! -d "$app_path" ]]; then
  print -u2 "App bundle not found: $app_path"
  exit 66
fi

rm -f "$dmg_path"
mkdir -p "$staging_directory"
cp -R "$app_path" "$staging_directory/LimitChecker.app"
ln -s /Applications "$staging_directory/Applications"
mkdir -p "$staging_directory/.background"
swift "$project_root/Scripts/create-dmg-background.swift" "$staging_directory/.background/installer-background.png"

hdiutil create \
  -volname "LimitChecker" \
  -size 20m \
  -fs APFS \
  -ov \
  "$rw_dmg_path" >/dev/null

attachment=$(hdiutil attach -readwrite -noverify -noautoopen "$rw_dmg_path")
device=$(print "$attachment" | awk '/^\/dev\/disk/ { print $1; exit }')
volume_path=$(print "$attachment" | awk '$NF ~ /^\/Volumes\// { print $NF; exit }')
ditto "$staging_directory" "$volume_path"

osascript <<EOF
tell application "Finder"
  tell disk "LimitChecker"
    open
    set containerWindow to container window
    set current view of containerWindow to icon view
    set toolbar visible of containerWindow to false
    set statusbar visible of containerWindow to false
    set bounds of containerWindow to {180, 180, 940, 620}
    set viewOptions to icon view options of containerWindow
    set arrangement of viewOptions to not arranged
    set icon size of viewOptions to 112
    set background picture of viewOptions to POSIX file "$volume_path/.background/installer-background.png"
    set position of item "LimitChecker.app" of containerWindow to {190, 188}
    set position of item "Applications" of containerWindow to {570, 188}
    update without registering applications
    delay 1
    close containerWindow
  end tell
end tell
EOF

hdiutil detach "$device" >/dev/null
device=""
hdiutil convert "$rw_dmg_path" -format UDZO -o "$dmg_path" -ov >/dev/null

print "$dmg_path"
