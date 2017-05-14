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
        doc.div(:id => "sidebar") {
          if section == "library"
            doc.div.bold.text "My Library"
          else
            doc.div {
              doc.a(:href => "/library").text "My Library"
            }
          end

          RetroFlix::SYSTEMS.keys.each { |sys|
            doc.div {
              if section == sys.to_s
                doc.div.bold.text sys
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
