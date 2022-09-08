class UserView
  def initialize(user)
    @user = user
  end

  def html_get
    raise ArgumentsError.new, "Bad data from database: #{@user.errors}" if @user.errors.any?

    case @user.gen
    when ':m'
      bgcolor = 'blue'
    when ':f'
      bgcolor = 'pink'
    when ':nb'
      bgcolor = 'gray'
    end
    age_readable = time_convert(@user.age)

    %(<html>
    <body bgcolor = #{bgcolor}>
    <h1>#{@user.name}</h1>
    <p>#{age_readable['years']} years, #{age_readable['months']} months, #{age_readable['days']} days</p>
    </body>
    </html>)
  end
end
