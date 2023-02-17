# frozen_string_literal: true

class Response
  attr_reader :code, :headers, :body, :background_color, :user_name, :years, :months, :days

  def initialize(response)
    @code = response[0]
    @headers = response[1]
    @body = response[2].join('')
  end

  def html?
    @body.include?('<html>')
  end

  def parse_html_body
    @background_color = @body.split(/\W+/)[6]
    @user_name = @body.split(/\W+/)[20]
    @years = @body.split(/\W+/)[35].to_i
    @months = @body.split(/\W+/)[37].to_i
    @days = @body.split(/\W+/)[39].to_i
  end
end
