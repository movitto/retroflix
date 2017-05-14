# RetroFlix - Web based retro game downloader & library manager

**RetroFlix** is a frontend to download and manage legacy & retro applications and launch them using their target emulators.

Currently only one game db and a handfull of systems are supported, but more may be added at some point, depending on interest.

**Important**: This software should only be used for *Legal* purposes, inorder to retrieve copies
of applications which the user already owns or otherwise has a legitimate license to / rights to use.

Currently the following sites &amp; systems are supported:

* [emuparadise](https://www.emuparadise.me/)
* N64
* SNES
* NES
* Sega Genesis / Master System

## Install

RetroFlix is built as a [Sinatra](http://www.sinatrarb.com/) web service.

To use [install Ruby](https://www.ruby-lang.org/en/) and install the following gems:

```$ gem install sinatra ruby-zip curb nokogiri```


If the previous produces any errors, check the gem documentation for the corresponding
dependencies (curb requires libcurl-dev which may need to be installed seperately).

Launch it with

```$ ruby server.rb```

And navigate to [http://localhost:4567](http://localhost:4567) to download and manage games!

**Note**: Inorder to play games you will need to download the emulator for the corresponding systems. See the  **emulators.rb** file for the current list of emulators used (may be configured there)


## Screens

<img src="https://raw.githubusercontent.com/wiki/movitto/retroflix/screens/my_library.png" width="40%"/>

<img src="https://raw.githubusercontent.com/wiki/movitto/retroflix/screens/game_info.png" width="40%" />

<img src="https://raw.githubusercontent.com/wiki/movitto/retroflix/screens/game_previews.png" width="40%"/>

<img src="https://raw.githubusercontent.com/wiki/movitto/retroflix/screens/game_list.png" width="40%"/>
