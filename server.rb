# Main sinatra application.
# Part of RetroFlix

require 'sinatra'
require_relative './library'
require_relative './scrape'
require_relative './archive'
require_relative './emulator'
require_relative './site'

GAMES_PER_PAGE = 5

# TODO use workers (sidekiq) to retrieve remote
# server contents (game lists, info, & contents).
# Will require async interaction & callbacks

# TODO as part of this ensure multiple requests are
# queued and/or block subsequent content downloads
# until first is completed

# Landing page, just render layout & title
get '/' do
  layout("/") { |doc|
    doc.h1 "RetroFlix"
  }
end

# Render list of all games for a system
get "/system/:system" do
  system = validate_system!(params)
  games = RetroFlix.games_for(system.intern)

  layout(system) { |doc|
    doc.h3.text "Games for #{system}"
    games.keys.each { |game|
      doc.div {
        game_path = "#{system}/#{URI.encode(game)}"
        info_path = "/game/#{game_path}"
        play_path = "/play/#{game_path}"
        dl_path   = "/download/#{game_path}"

        doc.a(:href => info_path).text game

        if RetroFlix.have_game?(system, game)
          doc.a(:href => play_path, :class => "play_link").text "P"

        else
          doc.a(:href => dl_path, :class => "dl_link").text "D"
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

  start_index  = (num-1)*GAMES_PER_PAGE
  end_index    = [start_index+GAMES_PER_PAGE-1, games.size-1].min

  is_first  = start_index == 0
  is_last   = end_index == (games.size - 1)
  last_page = (games.size / GAMES_PER_PAGE).to_i + 1

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
    RetroFlix::SYSTEMS.keys.each_with_index { |sys, i|
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

      unless i == (RetroFlix::SYSTEMS.size-1)
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

  layout(system) { |doc|
    doc.h3 game
    doc.text "for the "
    doc.a(:href => "/system/#{system}/1").text system
    doc.div {
      game_path = "#{system}/#{URI.encode(game)}"
      play_path = "/play/#{game_path}"
      dl_path   = "/download/#{game_path}"

      if RetroFlix.have_game?(system, game)
        doc.a(:href => "#{play_path}", :class => "play_link").text "Play"
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

# Download specified game
get "/download/:system/:game" do
  system = validate_system!(params)

  game   = URI.decode(params[:game])

  puts "Downloading #{game} for #{system}"

  downloaded = RetroFlix::download(system.intern, game)
  extracted  = RetroFlix.extract_archive(downloaded)
  RetroFlix.write_game(system, game, extracted)

  redirect "/game/#{system}/#{URI.encode(game)}"
end
