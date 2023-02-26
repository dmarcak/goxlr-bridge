# GoXLR Bridge

GoXLR Bridge is an application that provides RESTish API which allow change profile and routing table in [TC Helicon GoXLR](https://www.tc-helicon.com/product.html?modelCode=P0CQK) via simple HTTP request.

Created after about year of being irritated by manually changing routing table in GoXLR App. Now, I can play a music through my speakers without any distraction, using one simple click on my keyboard!

App works using exactly same principle as GoXLR Plugin to [Elgato Stream Deck](https://www.elgato.com/stream-deck), so both apps can't be used at the same time.

## Requirements

The application requires [Dart](https://dart.dev/) version 2.16.0 or higher.

## Build

Clone content of this repository

```bash
git@gitlab.com:dmarcak/goxlr-bridge.git
```

Download all required dependencies

```bash
dart pub get
```

Then, compile source code to executable format

```bash
dart compile exe bin/goxlr_bridge.dart
```

Command above will produce `goxlr_bridge.exe` file in bin folder.

## Configuration
### General
The application is prepared to run without any further configuration in case of running on the same machine as GoXLR App.

The GoXLR Bridge is listening on a TCP port 6805, it can't be changed due to lack of possibility to configure this in a GoXLR App.

### Remote machine
The GoXLR App allows connect to Stream Deck which is on different PC than GoXLR.  

If GoXLR Bridge is running on separate machine, e.g. second PC, you have to bind it to a network interface which allows remote connection. To do this, use `--host` flag, `-h` in short. 

For example `goxlr_bridge.exe -h 0.0.0.0` allows app for listen on all available network interfaces.

## Usage
### GoXLR
Just connect GoXLR App to "Stream Deck". If GoXLR Bridge is running on separate machine, click on checkbox `Stream Deck on Non-GoXLR PC` and provide ip address.
Then, click `Connect/Reconnect to Stream Deck App`.
In case of any issues try restarting GoXLR App.

### API
[Documentation](doc/openapi.yaml) in OpenApi format is available in `doc` folder.

### Examples
#### Toggle `Line Out` output for `Music` input with python script
```python
import http.client
http.client.HTTPConnection('127.0.0.1', 6805).request('POST', '/api/routing-table', '{"input": "Music", "output": "LineOut", "action": "Toggle"}')
```

#### Change profile to one called `Sleep` with python script
```python
import http.client
http.client.HTTPConnection('127.0.0.1', 6805).request('POST', '/api/profile', '{"name": "Sleep"}')
```

## Troubleshooting
In case of any issues add `--debug` flag to start parameters.

## License
GoXLR Bridge is licensed under the MIT License, see LICENSE for more information.

## Disclaimer
This project is not supported by or affiliated in any way with TC-Helicon. For the official GoXLR software, please refer to their website.