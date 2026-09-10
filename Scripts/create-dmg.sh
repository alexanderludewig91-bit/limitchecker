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
staging_directory=$(mktemp -d)

cleanup() {
  rm -rf "$staging_directory"
}
trap cleanup EXIT

if [[ ! -d "$app_path" ]]; then
  print -u2 "App bundle not found: $app_path"
  exit 66
fi

rm -f "$dmg_path"
cp -R "$app_path" "$staging_directory/LimitChecker.app"
ln -s /Applications "$staging_directory/Applications"

hdiutil create \
  -volname "LimitChecker" \
  -srcfolder "$staging_directory" \
  -format UDZO \
  -ov \
  "$dmg_path" >/dev/null

print "$dmg_path"
