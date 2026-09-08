# Contributing

## Development checks

Run these before opening a pull request:

```zsh
swift build
python3 -m unittest discover -s tests -v
./Scripts/build-app.sh
```

Do not add credentials, usage exports, or Application Support history files to
the repository. Keep the app free of network calls and third-party analytics.

## Scope

LimitChecker deliberately depends on the official locally installed CLIs. Do
not add code that extracts their tokens, browser cookies, or Keychain items.
