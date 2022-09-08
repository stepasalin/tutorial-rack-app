# frozen_string_literal: true

require_relative 'user/section'
require_relative 'html_helper'

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
    base_html(@user.name,
              "<div style=\"background-color:#{COLORS[@user.gender]};\">
                #{user_section(@user)}
              </div>")
  end
end
