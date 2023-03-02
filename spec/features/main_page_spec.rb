require_relative '../spec_helper.rb'

describe 'Base Page' do

  before(:each) { User.delete_all }

  it 'creates the user' do
    visit 'http://localhost:3000/'

    create_section = find('div[id="root"] > div:nth-of-type(2)')

    name_input = create_section.find('input[id="name"]')
    gender_input = create_section.find('input[id="gender"]')
    age_input = create_section.find('input[id="age"]')
    create_button = create_section.find(:button, 'Create User')
    # HELP: google <- 'capybara cheat sheet'

    name = 'vasya'

    name_input.set name
    age_input.set 123
    gender_input.set 'm'
    create_button.click
    # 99% = set + click
    sleep 6

    expect(User.find(name)).not_to be_nil
  end
end