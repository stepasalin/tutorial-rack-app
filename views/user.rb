
# На вход класса Юзер
class UserView

  def initialize(user)
    @user = user
  end

  def generate_html
    %{
    <html>
      <head>
        <title>#{@user.name} page</title>
      </head>
      <body style='background-color: #{user_gender_background_color(@user.gender)}'>
        <h3>Hello #{@user.name}.</h3>
        <p>You are #{user_gender_output(@user.gender)}.</p>
        <p>You are #{user_age_years(@user.age)} years #{user_age_months(@user.age)} months and #{user_age_days(@user.age)} days old.</p>
      </body>
    </html>
    }
  end


  def user_gender_output(user_gender)
    vocabulary = {                      # зачем?
      :m => 'Man',
      :f => 'Woman',
      :nb => 'Just a nice person'
    }
    mapping = {
      m: 'Man',
      f: 'Woman',
      nb: 'Just a nice person'
    }

    mapping[user_gender]

    if user_gender == :m
      'man'
    elsif user_gender == :f
      'woman'
    else
      'just a nice person'
    end
  end


  def user_gender_background_color(user_gender)
    if @user.gender == :m
      'DeepSkyBlue'
    elsif @user.gender == :f
      'pink'
    elsif @user.gender == :nb
      'grey'
    end
  end


  def user_age_years(user_age)
    user_age / (365*24*60*60)
  end


  def user_age_months(user_age)
    user_age % (365*24*60*60) / (30*24*60*60)
  end


  def user_age_days(user_age)
    user_age % (365*24*60*60) % (30*24*60*60) / (24*60*60)
  end
end