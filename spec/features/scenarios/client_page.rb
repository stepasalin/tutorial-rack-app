# frozen_string_literal: true

class ClientPageScenario
  include RSpec::Matchers

  def initialize
    @index_page = IndexPage.new
  end

  def open_user_page
    @index_page.load
  end

  def input_user_info(name, age, gender)
    @index_page.create_and_update_section.name_input.set name
    @index_page.create_and_update_section.age_input.set age
    @index_page.create_and_update_section.gender_input.set gender
  end

  def click_create_user_button
    @index_page.create_and_update_section.create_user_button.click
    @index_page.create_and_update_section.wait_until_preloader_invisible
  end

  def check_user_data_is_correctly_stored(user)
    user_in_base = User.find(user.name)
    expect(user.to_json).to eq(user_in_base.to_json)
  end

  def check_create_user_respond_message_shown
    message = 'new user is created'
    expect(@index_page.create_and_update_section.success_message).to have_text(message)
  end

  def check_username_is_taken_error_message_shown
    message = 'User is already created'
    expect(@index_page.create_and_update_section.error_message).to have_text(message)
  end

  def check_user_with_invalid_name_error_message_shown
    message = 'Invalid name. Must contain only latin alphabet characters, numbers and have length from 1 to 30 chars. No spaces allowed.'
    expect(@index_page.create_and_update_section.error_message).to have_text(message)
  end

  def check_user_with_invalid_age_error_message_shown
    message = 'Invalid age. Must be integral number not less than 0.'
    expect(@index_page.create_and_update_section.error_message).to have_text(message)
  end

  def check_user_with_invalid_gender_error_message_shown
    message = 'Invalid gender. Must be Male, Female or Nonbinary'
    expect(@index_page.create_and_update_section.error_message).to have_text(message)
  end

  def get_user(name)
    @index_page.read_section.name_input.set name
    @index_page.read_section.find_user_button.click
    @index_page.read_section.wait_until_preloader_invisible
  end

  def check_get_user_respond_message_shown(user)
    message = "Name: #{user.name}\nGender: #{user.gender}\nAge: #{user.age}"
    expect(@index_page.read_section.success_message.text).to eq(message)
  end

  def check_get_user_not_found_message_shown
    message = 'User is not found'
    expect(@index_page.read_section.error_message.text).to eq(message)
  end

  def click_update_user_button
    @index_page.create_and_update_section.update_user_button.click
    @index_page.create_and_update_section.wait_until_preloader_invisible
  end

  def check_update_user_respond_message_shown
    message = 'User is updated!'
    expect(@index_page.create_and_update_section.success_message).to have_text(message)
  end

  def check_update_user_not_found_message_shown
    message = 'User is not found'
    expect(@index_page.create_and_update_section.error_message).to have_text(message)
  end

  def check_update_user_invalid_age_error_message_shown
    message = 'Invalid age. Must be integral number not less than 0.'
    expect(@index_page.create_and_update_section.error_message).to have_text(message)
  end

  def check_update_user_invalid_gender_error_message_shown
    message = 'Invalid gender. Must be Male, Female or Nonbinary'
    expect(@index_page.create_and_update_section.error_message).to have_text(message)
  end

  def delete_user(name)
    @index_page.delete_section.name_input.set name
    @index_page.delete_section.delete_user_button.click
    @index_page.delete_section.wait_until_preloader_invisible
  end

  def check_user_is_not_in_db(username)
    expect(REDIS_CONNECTION.exists(username)).to eq(0)
  end

  def check_delete_user_respond_message_is_shown
    message = 'deleted'
    expect(@index_page.delete_section.success_message).to have_text(message)
  end

  def check_delete_user_not_found_message_is_shown
    message = 'User is not found'
    expect(@index_page.delete_section.error_message).to have_text(message)
  end

  def click_get_users_button
    @index_page.get_all_users_section.get_users_button.click
    @index_page.get_all_users_section.wait_until_preloader_invisible
  end

  def check_all_usernames_are_shown
    expect(@index_page.get_all_users_section.users_list.map(&:text)).to match_array(User.list)
  end
end
