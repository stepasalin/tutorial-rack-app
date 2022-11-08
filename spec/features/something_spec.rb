require 'spec_helper'
require 'pry'
require_relative '../support/factories/user.rb'
require_relative '../support/randomizers.rb'
require_relative 'scenarios/scenario.rb'


describe 'Base Page' do
  
  it 'creates the user with valid params' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000/'
    user_params = UserFactory.generate_user
    scenario.create_user_with_params user_params
    scenario.check_params_from_db(user_params)
    scenario.check_success_message_on_page('OK')
  end

  it 'does not create the user with blank name and invalid age' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000/'
    invalid_user_params = UserFactory.generate_invalid_user name: "", gender: random_user_gender
    scenario.create_user_with_params invalid_user_params
    scenario.check_user_existing(invalid_user_params)
    scenario.check_error_message_on_page("[\"name length must be between 1 and 30, actual = 0\", \"age must be positive, actual = #{invalid_user_params.age}\"]")
  end

  it 'does not create the user with name length more than 30 and invalid gender' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000/'
    invalid_user_params = UserFactory.generate_invalid_user age: random_age_in_seconds
    scenario.create_user_with_params invalid_user_params
    scenario.check_user_existing(invalid_user_params)
    scenario.check_error_message_on_page("[\"name length must be between 1 and 30, actual = 31\", \"unknown gender, accepted = [\\\"fm\\\", \\\"m\\\", \\\"nb\\\"], actual = #{invalid_user_params.gender}\"]")
  end

  it 'does not create the exixting user' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000/'
    existing_user_params = UserFactory.create_user
    user_params = UserFactory.generate_user name: existing_user_params.name
    scenario.create_user_with_params user_params
    scenario.check_params_from_db(existing_user_params)
    scenario.check_error_message_on_page('user name already taken')
  end

  it 'edits the user with valid params' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000/'
    user_params = UserFactory.create_user
    new_user_params = UserFactory.generate_user name: user_params.name
    scenario.update_user_with_params new_user_params
    scenario.check_params_from_db(new_user_params)
    scenario.check_success_message_on_page(new_user_params.to_json.to_s)
  end

  it 'does not edits the user with invalid params' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000/'
    user_params = UserFactory.create_user
    invalid_user_params = UserFactory.generate_invalid_user name: user_params.name
    scenario.update_user_with_params invalid_user_params
    scenario.check_params_from_db(user_params)
    scenario.check_error_message_on_page("[\"unknown gender, accepted = [\\\"fm\\\", \\\"m\\\", \\\"nb\\\"], actual = #{invalid_user_params.gender}\", \"age must be positive, actual = #{invalid_user_params.age}\"]")
  end

  it 'does not create a new user when trying to update a non-existing user' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000'
    user_params = UserFactory.generate_user
    scenario.update_user_with_params user_params
    scenario.check_user_existing(user_params)
    scenario.check_error_message_on_page('User not found')
  end

  it 'fetches a user' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000'
    user_params = UserFactory.create_user
    scenario.search_user(user_params.name)
    scenario.check_user_name_shown_on_page(user_params.name)
    scenario.check_user_gender_shown_on_page(user_params.gender)
    scenario.check_user_age_shown_on_page(user_params.age)
  end

  it 'does not fetch any other users when trying to fetch a non-existent user' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000'
    user_params = UserFactory.create_user
    non_existing_user_params = UserFactory.generate_user
    scenario.search_user(non_existing_user_params.name)
    scenario.check_error_message_on_page('User not found')
  end

  it 'deletes a user' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000'
    user_params = UserFactory.create_user
    scenario.delete_user(user_params.name)
    scenario.check_user_existing(user_params)
    scenario.check_success_message_on_page("#{user_params.to_json.to_s} deleted")
  end

  it 'does not delet another user when trying to delete a non-exasting user' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000'
    user_params = UserFactory.create_user
    non_existing_user_params = UserFactory.generate_user
    scenario.delete_user(non_existing_user_params.name)
    scenario.check_params_from_db(user_params)
    scenario.check_error_message_on_page('User not found')
  end

  it 'fetches all users' do
    scenario = BasePageScenario.new
    visit 'http://localhost:3000'
    users_list = Random.rand(2..30).times.map { UserFactory.create_user.name }
    scenario.click_fetch_all_users_button
    scenario.check_user_list_eq(users_list)
  end
end