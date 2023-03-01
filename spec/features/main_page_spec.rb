require_relative '../spec_helper.rb'

describe 'Base Page' do

  before(:each) { User.delete_all }

  it 'creates the user' do
    Capybara.visit 'http://localhost:3000/'

    create_section = Capybara.find('div#root > div:nth-of-type(2)')
    name_input = create_section.find('#name')
    gender_input = create_section.find('#gender')
    age_input = create_section.find('#age')
    create_button = create_section.find(:button, 'Create User')

    name = 'vasya'
    name_input.set name
    age_input.set 123
    gender_input.set 'm'
    create_button.click
    
    sleep 6

    expect(User.find(name)).not_to be_nil
  end
end