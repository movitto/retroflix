# Main scraper, retrieve game list, information,
# and contents from remote server.
# Part of RetroFlix

require 'curb'
require 'nokogiri'

module RetroFlix
  ###

  BASE_URL = 'https://www.emuparadise.me'

  # TODO add support for other systems, dynamic system discovery
  SYSTEMS  = {:N64     => 'Nintendo_64_ROMs/List-All-Titles/9',
              :NES     => 'Nintendo_Entertainment_System_ROMs/List-All-Titles/13',
              :SNES    => 'Super_Nintendo_Entertainment_System_(SNES)_ROMs/List-All-Titles/5',
              :Genesis => 'Sega_Genesis_-_Sega_Megadrive_ROMs/List-All-Titles/6'}

  # Items of system games list
  GAMES_XPATH   = "//a[contains(@class, 'gamelist')]"

  # Screenshots on game info page
  SCREENS_XPATH = "//a[contains(@class, 'sc')]/img"

  # Descriptions on game info page
  DESC_XPATH    = "//div[contains(@id, 'game-descriptions')]/div[contains(@class, 'description-text')]"

  # Download link on game download page
  DL_XPATH      = "//a[contains(@id, 'download-link')]"

  # in hours
  CACHE_TIMEOUT = 24

  ###

  def self.cached(id, &setter)
    @cache            ||= {}
    @cache_timestamps ||= {}
    return @cache[id] if @cache.key?(id) &&
                        ((Time.now - @cache_timestamps[id]) <
                         (60 * 60 * CACHE_TIMEOUT))
    @cache_timestamps[id] = Time.now
    @cache[id]            = setter.call
  end

  ###

  def self.valid_system?(sys)
    return RetroFlix::SYSTEMS.keys.collect { |s| s.to_s }.include? sys
  end

  # Return a hash of all games (name to relative url of info page) for given systems
  def self.games_for(system)
    url = "#{BASE_URL}/#{SYSTEMS[system]}"
    cached(url) do
      http    = Curl.get url
      parser  = Nokogiri::HTML(http.body_str)
      games = {}
      parser.xpath(GAMES_XPATH).each { |node|
        href  = node.attribute("href").to_s
        title = node.text
        games[title] = href
      }   

      games
    end
  end

  ###

  # Return game url for given system / game
  def self.game_url_for(system, game)
    games_for(system)[game]
  end

  # Return parsed game info page
  def self.game_page_for(game_url)
    url  = "#{BASE_URL}#{game_url}"
    cached(url) do
      http = Curl.get url
      Nokogiri::HTML(http.body_str)
    end
  end

  # Return full urls to all game screens
  def self.screens_for(game_page)
    game_page.xpath(SCREENS_XPATH).collect { |node|
      src = node.attribute("data-original").to_s
      src == "" || src.nil? ? nil : "http:#{src}" 
    }.compact
  end

  # Return html content of game descriptions
  def self.desc_for(game_page)
    game_page.xpath(DESC_XPATH).collect { |node|
      node.inner_text.encode("UTF-8", invalid: :replace, undef: :replace)
    }
  end

  # Return hash of all metadata (screens, desc)
  # for system/game
  def self.game_meta_for(system, game)
    url  = game_url_for(system, game)
    page = game_page_for(url)
    {:screens => screens_for(page),
     :descs   => desc_for(page) }
  end

  ###

  # Return link to donwload game
  def self.download_link_for(game_url)
    url    = "#{BASE_URL}#{game_url}-download"

    http   = Curl.get(url) { |http|
      http.headers['Cookie'] = 'downloadcaptcha=1'
    }

    parser = Nokogiri::HTML(http.body_str)
    parser.xpath(DL_XPATH).first.attribute('href').to_s
  end

  # Download game, saves to system/game file
  def self.download(system, game, dl_url=nil)
    dl_url = download_link_for(game_url_for(system, game)) if dl_url.nil?

    url  = "#{BASE_URL}/#{dl_url}"

    http = Curl.get(url) { |http|
      http.headers['Referer'] = url
      http.follow_location = true
    }

    http.body_str
  end
end # module RetroFlix
