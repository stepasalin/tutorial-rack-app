require 'spec_helper'
require 'pry'

describe 'Base Page' do
  it 'creates the user' do
    visit 'http://localhost:3000/'
    user_params = UserGenerator.generate

    create_section = find('#root > div:nth-of-type(2)')
    name_input = create_section.find('#name')
    gender_input = create_section.find('#gender')
    age_input = create_section.find('#age')
    create_button = create_section.find(:button, 'Create User') # Capybara cheat sheet    

    name_input.set user_params.name
    age_input.set user_params.age
    gender_input.set user_params.gender
    create_button.click
    
    sleep 6

    expect(User.find(user_params.name)).to eq user_params
  end
end