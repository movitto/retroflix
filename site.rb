# Sinatra website helpers
# Part of RetroFlix

# Constructs the main layout of the application,
# providing callback mechanism for main content area
def layout(section, &inner)
  Nokogiri::HTML::Builder.new { |doc|
    doc.html {
      doc.head{
        doc.title "RetroFlix"

        doc.link(:rel  => "stylesheet",
                 :type => "text/css",
                 :href => "/style.css")
      }

      doc.body {
        doc.a(:href => "https://github.com/movitto/retroflix") {
          doc.img(:style => "position: absolute; top: 0; right: 0; border: 0;",
                  :src => "https://camo.githubusercontent.com/a6677b08c955af8400f44c6298f40e7d19cc5b2d/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677261795f3664366436642e706e67",
                  :alt => "Fork me on GitHub",
                  :"data-canonical-src" => "https://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png")
        }

        doc.div(:id => "sidebar") {
          if section == "/"
            doc.div.bold.text "RF"
          else
            doc.div {
              doc.a(:href => "/").text "RF"
            }
          end

          if section == "library"
            doc.div.bold.text "My Library"
          else
            doc.div {
              doc.a(:href => "/library").text "My Library"
            }
          end

          RetroFlix::systems.each { |sys|
            doc.div {
              if section == sys.to_s
                doc.div.bold.text sys
              elsif section == "#{sys}-game"
                doc.div.bold {
                  doc.a(:href => "/system/#{sys}/1").text sys
                }
              else
                doc.a(:href => "/system/#{sys}/1").text sys
              end
            }
          }
        }

        doc.div(:id => "main_content") {
          inner.call(doc) if inner
        }
      }
    }
  }.to_html
end

# Validates the system param
def validate_system!(params)
  system = params[:system]
  raise ArgumentError if !RetroFlix.valid_system?(system)
  system
end

# Validates the num param
def validate_num!(params)
  num = params[:num]
  Integer(num) # raises ArgumentError if invalid int
end

# Generate javascript invoked when download link is clicked
def dl_link_onclick(game)
  "alert(\"Downloading #{game}, refresh page momentarily to play...\")"
end
