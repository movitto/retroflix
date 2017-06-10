# Main sinatra application.
# Part of RetroFlix

require 'sinatra'
require_relative './lib/conf'
require_relative './lib/library'
require_relative './lib/scrape'
require_relative './lib/archive'
require_relative './lib/emulator'
require_relative './site'

# Landing page, just render layout & title
get '/' do
  layout("/") { |doc|
    doc.script(:type => "text/javascript",
               :src  => "slideshow.js")
    doc.h1(:id => "main_title",
           :class => "blink_me",
          :style  => "margin: auto;").text "RetroFlix"
    0.upto(5){ |n|
      doc.img(:class => "slideshow", :src => "slideshow/#{n}.jpg")
    }
  }
end

# Render list of all games for a system
get "/system/:system" do
  system = validate_system!(params)
  games = RetroFlix.games_for(system.intern)

  layout(system) { |doc|
    doc.h3.text "Games for #{system}"
    doc.a(:href => "/system/#{system}/1").text "Previews"

    games.keys.each { |game|
      doc.div {
        game_path = "#{system}/#{URI.encode(game)}"
        info_path = "/game/#{game_path}"
        play_path = "/play/#{game_path}"
        dl_path   = "/download/#{game_path}"

        doc.a(:href => info_path).text game

        if RetroFlix.have_game?(system, game)
          doc.text " - "
          doc.a(:href => play_path, :class => "play_link").text "[P]"

        else
          doc.text " - "
          doc.a(:href => dl_path, :class => "dl_link").text "[D]"
        end
      }
    }
  }
end

# Paginated list of games (w/ screenshots)
get "/system/:system/:num" do
  system = validate_system!(params)
  num    = validate_num!(params)
  games  = RetroFlix.games_for(system.intern)

  gpp = RetroFlix::Config.meta.games_per_page
  start_index  = (num-1)*gpp
  end_index    = [start_index+gpp-1, games.size-1].min

  is_first  = start_index == 0
  is_last   = end_index == (games.size - 1)
  last_page = (games.size / gpp).to_i + 1

  layout(system) { |doc|
    doc.h3.text "Games for #{system}"

    unless is_first
      doc.a(:href => "/system/#{system}/1").text "<< "
      doc.a(:href => "/system/#{system}/#{num-1}").text "< "
    end

    doc.a(:href => "/system/#{system}").text "All"

    unless is_last
      doc.a(:href => "/system/#{system}/#{num+1}").text " >"
      doc.a(:href => "/system/#{system}/#{last_page}").text " >>"
    end

    games.keys[start_index..end_index].each { |game|
      meta = RetroFlix::game_meta_for(system.intern, game)
      game_path = "#{system}/#{URI.encode(game)}"

      doc.div(:class => "game_preview"){
        doc.a(:href => "/game/#{game_path}") {
          doc.img(:src   => meta[:screens].first,
                  :class => "preview_screen")
        }

        doc.div(:class => "preview_text") {
          doc.a(:href => "/game/#{game_path}").text game
        }

        doc.div(:style => "clear: both;")
      }
    }
  }
end

# Games downloaded locally
get "/library" do
  layout("library") { |doc|
    RetroFlix::systems.each_with_index { |sys, i|
      doc.h3.text sys
      RetroFlix.library_games_for(sys).each { |game|
        game_path = "#{sys}/#{URI.encode(game)}"
        info_path = "/game/#{game_path}"
        play_path = "/play/#{game_path}"

        doc.div { |doc|
         doc.a(:href => "#{info_path}").text game
         doc.text "  "
         doc.a(:href => "#{play_path}", :class => "play_link").text "P"
        }
      }

      unless i == (RetroFlix::systems.size-1)
        doc.br
        doc.br
      end
    }
  }
end

# Game info page
get "/game/:system/:game" do
  system = validate_system!(params)
  game   = URI.decode(params[:game])
  meta   = RetroFlix::game_meta_for(system.intern, game)

  layout("#{system}-game") { |doc|
    doc.h3(:class => "game_title").text game
    doc.text "for the "
    doc.a(:href => "/system/#{system}/1").text system
    doc.div {
      game_path = "#{system}/#{URI.encode(game)}"
      play_path = "/play/#{game_path}"
      delete_path = "/delete/#{game_path}"
      dl_path   = "/download/#{game_path}"

      if RetroFlix.have_game?(system, game)
        doc.a(:href => "#{play_path}", :class => "play_link").text "[Play]"
        doc.text " / "
        doc.a(:href => "#{delete_path}", :class => "delete_link").text "[Delete]"

      else
        doc.a(:href => "#{dl_path}", :class => "dl_link").text "Download"
      end
    }

    meta[:descs].each_with_index { |desc, i|
      doc.div.text desc
      doc.hr if i == 0
    }

    meta[:screens].each { |screen|
      doc.img(:src => screen)
    }
  }
end

# Play specified game
get "/play/:system/:game" do
  system = validate_system!(params)
  game = URI.decode(params[:game])
  puts "Playing #{game}"

  RetroFlix::play_game(system.intern, game)

  redirect "/game/#{system}/#{game}"
end

# Play specified game
get "/delete/:system/:game" do
  system = validate_system!(params)
  game = URI.decode(params[:game])
  puts "Playing #{game}"

  RetroFlix::delete_game(system.intern, game)

  redirect "/game/#{system}/#{game}"
end

# Download specified game
get "/download/:system/:game" do
  system = validate_system!(params)

  game   = URI.decode(params[:game])

  puts "Downloading #{game} for #{system}"

  downloaded = RetroFlix::download(system.intern, game)
  name, extracted  = *RetroFlix.extract_archive(downloaded)
  RetroFlix.write_game(system, game, name, extracted)

  redirect "/game/#{system}/#{URI.encode(game)}"
end
