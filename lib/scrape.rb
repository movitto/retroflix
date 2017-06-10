# Main scraper, retrieve game list, information,
# and contents from remote server.
# Part of RetroFlix

require 'curb'
require 'nokogiri'

module RetroFlix
  def self.cached(id, &setter)
    @cache            ||= {}
    @cache_timestamps ||= {}
    return @cache[id] if @cache.key?(id) &&
                        ((Time.now - @cache_timestamps[id]) <
                         (60 * 60 * Config.meta.cache_time))
    @cache_timestamps[id] = Time.now
    @cache[id]            = setter.call
  end

  ###

  # TODO support using multiple databases (how resolve conflicts ?)
  def self.db_config
    @db_config ||= Config.databases[Config.databases.default]
  end

  def self.base_url
    @base_url ||= db_config.url
  end

  ###

  def self.systems
    db_config.systems.keys
  end

  def self.system_url(system)
    "#{base_url}/#{db_config.systems[system]}"
  end

  def self.valid_system?(sys)
    systems.collect { |s| s.to_s }.include? sys
  end

  ###

  # Return a hash of all games (name to relative url of info page) for given systems
  def self.games_for(system)
    url = system_url(system)
    cached(url) do
      http    = Curl.get url
      parser  = Nokogiri::HTML(http.body_str)
      games = {}
      parser.xpath(db_config.paths.games).each { |node|
        href  = node.attribute("href").to_s
        title = node.text
        games[title] = href unless db_config.omit.any? { |o| title =~ Regexp.new(o) }
      }

      games
    end
  end

  ###

  # Return game url for given system / game
  def self.game_url_for(system, game)
    "#{base_url}#{games_for(system)[game]}"
  end

  # Return download url for given system / game
  def self.download_url_for(system, game)
    "#{game_url_for(system, game)}-download"
  end

  # Return parsed game info page
  def self.game_page_for(system, game)
    url = game_url_for(system, game)
    cached(url) do
      Nokogiri::HTML(Curl.get(url).body_str)
    end
  end

  # Return full urls to all game screens
  def self.screens_for(game_page)
    game_page.xpath(db_config.paths.screens).collect { |node|
      src = node.attribute("data-original").to_s
      src == "" || src.nil? ? nil : "http:#{src}"
    }.compact
  end

  # Return html content of game descriptions
  def self.desc_for(game_page)
    game_page.xpath(db_config.paths.desc).collect { |node|
      node.inner_text.encode("UTF-8", invalid: :replace, undef: :replace)
    }
  end

  # Return hash of all metadata (screens, desc)
  # for system/game
  def self.game_meta_for(system, game)
    page = game_page_for(system, game)

    {:screens => screens_for(page),
     :descs   =>    desc_for(page) }
  end

  ###

  # Return link to donwload game
  def self.download_link_for(system, game)
    url = download_url_for(system, game)
    http = Curl.get(url) { |http|
      http.headers['Cookie'] = 'downloadcaptcha=1'
    }

    parser = Nokogiri::HTML(http.body_str)
    parser.xpath(db_config.paths.dl).first.attribute('href').to_s
  end

  # Download game, saves to system/game file
  def self.download(system, game)
    dl_url = download_link_for(system, game)

    url  = "#{base_url}/#{dl_url}"

    http = Curl.get(url) { |http|
      http.headers['Referer'] = url
      http.follow_location = true
    }

    http.body_str
  end
end # module RetroFlix
