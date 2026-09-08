# Privacy

LimitChecker is designed to read subscription-limit information locally.

## Data it reads

The native helper opens the Claude Code and Codex CLIs already installed on the
current Mac and issues their built-in `/usage` and `/status` commands. Those
CLIs authenticate using their own existing local sessions.

LimitChecker does not collect passwords, API keys, OAuth tokens, prompts, source
code, repository paths, chat content, or account identifiers.

## Data it stores

The app stores a rolling twelve-hour history containing only a timestamp and
two percentage values. The file is located at:

`~/Library/Application Support/LimitChecker/history.json`

Delete that file, or the entire `LimitChecker` directory in Application
Support, to remove the history.

## Network use

LimitChecker has no first-party server and does not send data to a service run
by this project. The installed Claude Code and Codex CLIs may contact their own
providers as part of their normal startup and authentication behavior. Their
privacy policies apply to that traffic.
