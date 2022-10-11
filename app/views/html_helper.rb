# frozen_string_literal: true

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