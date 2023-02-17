# frozen_string_literal: true

class UserView
  def initialize(user)
    @user = user
  end

  def create_html
    %(
      <html>
        <body style='background-color: #{page_color(@user.gender)}'>
          <h6 style="text-align:center;font-size:300%;background-color:Orange;">Hello chumba-#{@user.name}.</h5>
          <p>Glad to see <b>you</b> made it! </p>
          <p>You are #{convert_to_ymd_format(@user.age)} </p>
        </body>
      </html>
      )
  end
end
