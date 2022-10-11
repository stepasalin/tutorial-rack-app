require 'spec_helper'
require 'pry'

describe 'home page' do
  it 'welcomes the user' do
    page = MainPage.new
    visit 'http://localhost:3000/'
    name = 'Vasya'
    page.create_update.name.set name
    page.create_update.gender.set 'm'
    page.create_update.age.set 100500
    page.create_update.create_button.click
    page.wait_for_spinner
    page.user_list_section.fetch_button.click
    page.wait_for_spinner
    expect(page.user_list_section.user_names.map(&:text)).to match_array([name])
  end
end