# frozen_string_literal: true

require_relative '../helpers/time'

def base_html(title, child)
  "<!DOCTYPE html>
  <html>
  <head>
    <title>#{title}</title>
  </head>
    <body>
    #{child}
    </body>
  </html>"
end