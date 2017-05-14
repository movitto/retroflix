# RetroFlix - Web based retro game downloader & library manager

*RetroFlix* is frontend to download and manage legacy & retro applications and launch them using their target emulator.

Currently only one game db and a handfull of systems are supported, but more may be added at some point, depending on interest.

*Important*: This software should only be used for *Legal* purposes, inorder to retrieve copies
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

  $ gem install sinatra ruby-zip curb nokogiri


If the previous produces any errors, check the gem documentation for the corresponding
dependencies (curb requires libcurl-dev which may need to be installed seperately).

Launch it with

  $ ruby server.rb

And navigate to [http://localhost:4567](http://localhost:4567) to download and manage games!

## Screens
