# frozen_string_literal: true

require_relative '../helpers/http_errors'

class ErrorsCatcher
  attr_reader :router

  def initialize(router)
    @router = router
  end

  def handle
    @router.handle
  rescue UnprocessableUserError => e
    [422, {}, [e.validation_errors.to_s]]
  rescue UserNameAlreadyTakenError
    [409, {}, ['user name already taken']]
  rescue UserNotFoundError
    [404, {}, ['User not found']]
  rescue StandardError => e
    puts e.full_message
    internal_server_error
  end
end
