require_relative '../helpers/html_helper'

class UserView
  COLORS = {
    fm: 'pink',
    m: 'cyan',
    nb: 'grey'
  }.freeze
  def initialize(user)
    @user = user
  end

  def render
    return not_found unless @user

    doc = base_html(@user.name,
                    "<div style=\"background-color:#{COLORS[@user.gender]};\">
                    #{user_section(@user)}
                    </div>")
    [200, {}, [doc]]
  end

  def not_found
    [404, {}, [base_html('not found', '<h1>User not found</h1>')]]
  end
end
