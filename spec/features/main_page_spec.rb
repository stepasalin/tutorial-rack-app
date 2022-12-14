require 'spec_helper'
require 'pry'


class BasePageScenario
  include RSpec::Matchers
  def initialize
    @page = MainPage.new
  end

  def create_user_with_params(user_params)
    @page.user_create_update.name_input.set user_params.name
    @page.user_create_update.gender_input.set user_params.gender
    @page.user_create_update.age_input.set user_params.age
    @page.user_create_update.create_button.click
    @page.wait_for_spinner
  end

  def click_fetch_all_users_button
    @page.user_list.fetch_button.click
    @page.wait_for_spinner
  end

  def check_user_list_eq(user_names)
    expect(@page.user_list.user_names.map(&:text)).to match_array(user_names)
  end
end

describe 'Base Page' do
  it 'creates the user' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000/'
    user_params = UserGenerator.generate
    scenario.create_user_with_params user_params
    scenario.click_fetch_all_users_button
    scenario.check_user_list_eq [user_params.name]
  end
end