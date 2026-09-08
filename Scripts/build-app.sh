#!/bin/zsh
set -euo pipefail

project_root=${0:A:h:h}
app_path="$project_root/dist/LimitChecker.app"
architectures=(arm64 x86_64)
signing_identity="${CODESIGN_IDENTITY:--}"

cd "$project_root"
for architecture in "${architectures[@]}"; do
  swift build -c release --arch "$architecture" --product LimitChecker
  swift build -c release --arch "$architecture" --product LimitProbe
done

rm -rf "$app_path"
mkdir -p "$app_path/Contents/MacOS" "$app_path/Contents/Resources"
lipo -create \
  "$project_root/.build/arm64-apple-macosx/release/LimitChecker" \
  "$project_root/.build/x86_64-apple-macosx/release/LimitChecker" \
  -output "$app_path/Contents/MacOS/LimitChecker"
lipo -create \
  "$project_root/.build/arm64-apple-macosx/release/LimitProbe" \
  "$project_root/.build/x86_64-apple-macosx/release/LimitProbe" \
  -output "$app_path/Contents/Resources/LimitProbe"
cp "$project_root/App/Info.plist" "$app_path/Contents/Info.plist"

sign_options=(--force --sign "$signing_identity")
if [[ "$signing_identity" != "-" ]]; then
  sign_options+=(--options runtime --timestamp)
fi
codesign "${sign_options[@]}" "$app_path/Contents/Resources/LimitProbe"
codesign "${sign_options[@]}" "$app_path"

echo "$app_path"
