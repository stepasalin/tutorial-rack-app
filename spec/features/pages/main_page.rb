require 'site_prism'

class MainPage < SitePrism::Page
  element :spinner, '.loading-spinner'
  section :create_update, '#root > div:nth-of-type(2)' do
    element :name, '#name'
    element :gender, '#gender'
    element :age, '#age'
    element :create_button, :button, 'Create User'
    element :update_button, :button, 'Update User'
  end
  section :user_list_section, '#root > div:nth-of-type(4)' do
    elements :user_names, 'li'
    element :fetch_button, :button, 'Fetch All userNames'
  end
  elements :inputs, 'input'

  def wait_for_spinner
    wait_until_spinner_visible
    wait_until_spinner_invisible
  end
end