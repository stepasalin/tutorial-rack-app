# frozen_string_literal: true

class ClientPageScenario
  include RSpec::Matchers

  def initialize
    @index_page = IndexPage.new
  end

  def open_user_page
    @index_page.load
  end

  def create_user(name, age, gender)
    @index_page.create_section.name_input.set name
    @index_page.create_section.age_input.set age
    @index_page.create_section.gender_input.set gender
    @index_page.create_section.create_user_button.click
    @index_page.create_section.wait_until_preloader_invisible
  end

  def check_user_saved(user)
    user_in_base = User.find(user.name)
    expect(user.to_json).to eq(user_in_base.to_json)
  end

  def check_create_user_respond_message_shown
    expect(@index_page.create_section.success_message).to have_text('new user is created')
  end

  def get_user(name)
    @index_page.read_section.name_input.set name
    @index_page.read_section.find_user_button.click
    @index_page.read_section.wait_until_preloader_invisible
  end

  def check_get_user_respond_message_shown(user)
    text = "Name: #{user.name}\nGender: #{user.gender}\nAge: #{user.age}"
    expect(@index_page.read_section.success_message.text).to eq(text)
  end
end
