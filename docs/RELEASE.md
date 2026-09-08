# Release guide

## Local unsigned test build

```zsh
./Scripts/build-app.sh
./Scripts/create-release.sh 0.1.0
```

This creates a universal ZIP and a SHA-256 checksum in `dist/`. An ad-hoc
signature is appropriate for local testing only.

## Developer-ID signing and notarization

For public downloads, enroll in the Apple Developer Program and use a
`Developer ID Application` certificate. Set its keychain identity before the
build:

```zsh
export CODESIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)"
./Scripts/create-release.sh 0.1.0
```

Create a ZIP with `ditto -c -k --keepParent`, submit that ZIP with `xcrun
notarytool submit`, wait for acceptance, staple the ticket with `xcrun stapler
staple`, and then create the final download ZIP.

## GitHub Actions secrets

The release workflow supports these optional secrets:

- `APPLE_CERTIFICATE_BASE64`: Developer-ID `.p12`, base64 encoded
- `APPLE_CERTIFICATE_PASSWORD`
- `APPLE_KEYCHAIN_PASSWORD`
- `APPLE_SIGNING_IDENTITY`
- `APPLE_ID`
- `APPLE_TEAM_ID`
- `APPLE_APP_PASSWORD`

When all signing and notarization secrets are present, a version tag creates a
notarized GitHub Release with a universal ZIP and checksum. Without them, the
workflow creates an unsigned test artifact only; do not publish that artifact
as a normal public download.
