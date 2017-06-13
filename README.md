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

## Dependencies

RetroFlix is built as a [Sinatra](http://www.sinatrarb.com/) web service and shipped as a rubygem. To use it you will need to install the underlying dependencies.

On Fedora 25:

```$ sudo dnf install rubygems ruby-devel zlib-devel libcurl-devel redhat-rpm-config```

On Ubuntu 16.04:

```$sudo apt-get install ruby ruby-dev zlib1g-dev libcurl4-gnutls-dev```

**Note** I was able to install and run RetroFlix on a Raspberry PI running [Rasbian Jessie](https://www.raspberrypi.org/downloads/raspbian/) 4.4 after installing
the latest stable ruby version via [rbenv](https://github.com/rbenv/rbenv).

Setup of that is outside the scope of this article but after ruby 2.4.1 is installed
and activated, the Ubuntu instructions can be followed.

## Install

Install the actual application with:

```$ gem install --user-install retroflix```

**Note** the ***--user-install*** flag is specified so as to install RetroFlix and gem dependencies
to your user's home dir. Use the following command if you wish to install the application systemwide:

```$ sudo gem install retroflix```


Simply launch the application with:

```$ rf```

And navigate to [http://localhost:4567](http://localhost:4567) to download and manage games!

**Note** if you get an error stating **rf command not found**, most likely your rubygems binary
path needs to be added to your run path. To do so, run the following command:

```export PATH=$PATH:~/.gem/ruby/2.3.0/bin```

(replacing 2.3.0 w/ the version of Ruby you have installed locally)

## Emulators

Inorder to play games you will need to download the emulator for the corresponding systems.

Currenly the default emulators are:

* gens for the Sega Genesis / Master Drive
* zsnes for Nintendo NES & SNES
* mupen64 for Nintendo 64

If these are not available on your system, copy the [Config File](https://raw.githubusercontent.com/movitto/retroflix/master/retroflix.yml)
to ~/.retroflix.yml and edit it to reference the emulators you have locally.

## Screens

<img src="https://raw.githubusercontent.com/wiki/movitto/retroflix/screens/my_library.png" width="40%"/>

<img src="https://raw.githubusercontent.com/wiki/movitto/retroflix/screens/game_info.png" width="40%" />

<img src="https://raw.githubusercontent.com/wiki/movitto/retroflix/screens/game_previews.png" width="40%"/>

<img src="https://raw.githubusercontent.com/wiki/movitto/retroflix/screens/game_list.png" width="40%"/>
