# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../scenarios/client_page'
require_relative '../../support/web/index_page'
require_relative '../../../helpers/spec/api/test_user'

describe 'Base Page' do
  before(:each) { User.delete_all }
  let(:scenario) { ClientPageScenario.new }

  it 'creates user' do
    user = TestUser.create

    scenario.open_user_page
    scenario.create_user(user.name, user.age, user.gender)
    scenario.check_user_saved(user)
    scenario.check_create_user_respond_message_shown
  end

  it 'gets user' do
    user = TestUser.save

    scenario.open_user_page
    scenario.get_user(user.name)
    scenario.check_get_user_respond_message_shown(user)
  end
end
