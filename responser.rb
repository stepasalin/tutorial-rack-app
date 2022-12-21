# frozen_string_literal: true

class Response
  attr_reader :answer

  def initialize
    @answer = [nil, {}, nil]
  end

  def invalid_input(validity_errors)
    @answer[0] = 422
    @answer[2] = validity_errors
  end

  def duplicated_user
    @answer[0] = 409
    @answer[2] = ['User is already created']
  end

  def user_is_created
    @answer[0] = 201
    @answer[2] = ['new user is created!']
  end
end
