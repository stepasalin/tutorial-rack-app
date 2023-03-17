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
    scenario.input_user_info(user.name, user.age, user.gender)
    scenario.click_create_user_button
    scenario.check_user_data_is_correctly_stored(user)
    scenario.check_create_user_respond_message_shown
  end

  it 'fails to create user if name is taken' do
    user_in_base = TestUser.save
    duplicated_user = TestUser.create name: user_in_base.name

    scenario.open_user_page
    scenario.input_user_info(duplicated_user.name, duplicated_user.age, duplicated_user.gender)
    scenario.click_create_user_button
    scenario.check_user_data_is_correctly_stored(user_in_base)
    scenario.check_username_is_taken_error_message_shown
  end

  it 'fails to create user with invalid name' do
    invalid_name_user = TestUser.invalid_name
    
    scenario.open_user_page
    scenario.input_user_info(invalid_name_user.name, invalid_name_user.age, invalid_name_user.gender)
    scenario.click_create_user_button
    scenario.check_user_is_not_in_db(invalid_name_user.name)
    scenario.check_user_with_invalid_name_error_message_shown
  end

  it 'fails to create user with invalid age' do
    invalid_age_user = TestUser.invalid_age

    scenario.open_user_page
    scenario.input_user_info(invalid_age_user.name, invalid_age_user.age, invalid_age_user.gender)
    scenario.click_create_user_button
    scenario.check_user_is_not_in_db(invalid_age_user.name)
    scenario.check_user_with_invalid_age_error_message_shown
  end

  it 'fails to create user with invalid gender' do
    invalid_gender_user = TestUser.invalid_gender

    scenario.open_user_page
    scenario.input_user_info(invalid_gender_user.name, invalid_gender_user.age, invalid_gender_user.gender)
    scenario.click_create_user_button
    scenario.check_user_is_not_in_db(invalid_gender_user.name)
    scenario.check_user_with_invalid_gender_error_message_shown
  end

  it 'gets user' do
    user = TestUser.save

    scenario.open_user_page
    scenario.get_user(user.name)
    scenario.check_get_user_respond_message_shown(user)
  end

  it 'fails to get unexisting user' do
    user = TestUser.create

    scenario.open_user_page
    scenario.get_user(user.name)
    scenario.check_get_user_not_found_message_shown
  end

  it 'updates user' do
    old_user = TestUser.save gender: :f
    updated_user_params = TestUser.create name: old_user.name, gender: %w[m nb].sample,
                                          age: rand(1_000_000_000)
    scenario.open_user_page
    scenario.input_user_info(updated_user_params.name, updated_user_params.age, updated_user_params.gender)
    scenario.click_update_user_button
    scenario.check_user_data_is_correctly_stored(updated_user_params)
    scenario.check_update_user_respond_message_shown
  end

  it 'fails to update unexisting user' do
    user = TestUser.create

    scenario.open_user_page
    scenario.input_user_info(user.name, user.age, user.gender)
    scenario.click_update_user_button
    scenario.check_user_is_not_in_db(user.name)
    scenario.check_update_user_not_found_message_shown
  end

  it 'fails to update user with invalid age' do
    user = TestUser.save
    updated_user_params = TestUser.invalid_age name: user.name

    scenario.open_user_page
    scenario.input_user_info(updated_user_params.name, updated_user_params.age, updated_user_params.gender)
    scenario.click_update_user_button
    scenario.check_user_data_is_correctly_stored(user)
    scenario.check_update_user_invalid_age_error_message_shown
  end

  it 'fails to update user with invalid gender' do
    user = TestUser.save
    updated_user_params = TestUser.invalid_gender name: user.name

    scenario.open_user_page
    scenario.input_user_info(updated_user_params.name, updated_user_params.age, updated_user_params.gender)
    scenario.click_update_user_button
    scenario.check_user_data_is_correctly_stored(user)
    scenario.check_update_user_invalid_gender_error_message_shown
  end

  it 'deletes user' do
    user = TestUser.save

    scenario.open_user_page
    scenario.delete_user(user.name)
    scenario.check_user_is_not_in_db(user.name)
    scenario.check_delete_user_respond_message_is_shown
  end

  it 'fails to delete unexisting user' do
    user = TestUser.create

    scenario.open_user_page
    scenario.delete_user(user.name)
    scenario.check_user_is_not_in_db(user.name)
    scenario.check_delete_user_not_found_message_is_shown
  end

  it 'gets all users' do
    5.times do
      TestUser.save
    end
    scenario.open_user_page
    scenario.click_get_users_button
    scenario.check_all_usernames_are_shown
  end
end

#found bug - age format is not converted