# frozen_string_literal: true

def base_html(title, children)
  "<!DOCTYPE html>
  <html>
  <head>
    <title>#{title}</title>
  </head>
    <body>
    #{children}
    </body>
  </html>"
end

def user_section(user)
  "<div>
    <p>name: #{user.name}</p>
    <p>gender: #{user.gender}</p>
    <p>age: #{user.age / 31_556_952}</p>
  </div>"
end
