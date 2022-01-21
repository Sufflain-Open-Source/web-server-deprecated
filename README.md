# Sufflain's web server

Licensed under the **GNU AGPLv3**. For more, read the [LICENSE](./LICENSE) file.

Images are licensed under the **Creative Commons Attribution-NonCommercial-NoDerivatives 4**.
For more, read the [LICENSE](./img/LICENSE.md) file.

## Docker container demo
*We use curl to test the website availablility.*
[![asciicast](https://asciinema.org/a/dyJlbcB5bp9InrUjxXsV9YPKp.svg)](https://asciinema.org/a/dyJlbcB5bp9InrUjxXsV9YPKp?speed=1.5)

## Cloning the repo
```bash
git clone --recurse-submodules https://gitlab.com/Sufflain/web-server.git
```

## Project configuration
1. Go to the *web/app* directory and follow the client app [instructions](https://gitlab.com/Sufflain/web-client#project-configuration).
2. Create a "*private*" directory with an "*aconf*" file which contains the Google Analytics config string.

## Build
### Docker
```bash
make docker
```

Issuing this command results in building a docker image tagged as "*sufflain-web-server*."

### Standard
1. Get the dependencies:
```bash
dart pub get
```

1. Run *make*. Use the build target depending on your system.
```bash
make build/sflw
```

*or*

```powershell
make build/sflw.exe
```

## Usage
**Run the app from the root project directory!**

- Get help:
```bash
build/sflw -h
```

- Listen on a specified IP address:
```bash
build/sflw -a <x.x.x.x>
```

*`<x.x.x.x>`* is an IP address without angle brackets.

- Use a specific TCP port:
```bash
build/sflw -p <tcp-port-number>
```

*`<tcp-port-number>`* is a TCP port number without angle brackets.


**The IP address and the TCP port are optional. The default socket is _`127.0.0.1:80`_.**

## Commit Message Guidelines
We use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) to format our commit
messages.

## Libraries
- [html](https://pub.dev/packages/html) - Copyright (c) 2006-2012 The Authors
- [resource_portable](https://pub.dev/packages/resource_portable) - Copyright 2015, the Dart project authors. All rights reserved.
- [shelf_router](https://pub.dev/packages/shelf_router) - [Authors](https://github.com/google/dart-neats/blob/master/AUTHORS)
- [shelf_virtual_directory](https://pub.dev/packages/shelf_virtual_directory) - Copyright (c) 2020 Ratakondala Arun
- [args](https://pub.dev/packages/args) - Copyright 2013, the Dart project authors.