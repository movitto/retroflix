# -*- encoding: utf-8 -*-

$LOAD_PATH.push File.expand_path("lib")
GEM_NAME = 'retroflix'

PKG_FILES =
  Dir.glob('*.rb') + Dir.glob('lib/*.rb') +
  ['MIT-LICENSE', 'README.md', 'retroflix.yml']

Gem::Specification.new do |s|
    s.name    = "retroflix"
    s.version = '0.0.3'
    s.files   = PKG_FILES
    s.executables   = ['rf']

    s.add_dependency('sinatra',  '~> 2.0')
    s.add_dependency('nokogiri', '~> 1.8')
    s.add_dependency('rubyzip',  '~> 1.2')
    s.add_dependency('curb',     '~> 0.9.3')
    s.add_dependency('workers',  '~> 0.6')

    s.authors = ["Mo Morsi"]
    s.email = "mo@morsi.org"
    s.description = %q{Retro Game Library Manager}
    s.summary = %q{Manage collections of Retro games using an easy web interface, launch them right from the browser!}
    s.homepage = %q{http://github.com/movitto/retroflix}
    s.licenses = ["MIT"]
end
