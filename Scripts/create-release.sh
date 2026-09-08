#!/bin/zsh
set -euo pipefail

if [[ $# -ne 1 ]]; then
  print -u2 "Usage: $0 <version>"
  exit 64
fi

project_root=${0:A:h:h}
version="$1"
archive_path="$project_root/dist/LimitChecker-$version-macos-universal.zip"

"$project_root/Scripts/build-app.sh"
rm -f "$archive_path" "$archive_path.sha256"
ditto -c -k --keepParent "$project_root/dist/LimitChecker.app" "$archive_path"
shasum -a 256 "$archive_path" > "$archive_path.sha256"

print "$archive_path"
