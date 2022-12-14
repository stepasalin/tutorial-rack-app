require 'site_prism'

class MainPage < SitePrism::Page
  element :loading_spinner, '.spinner-container'
  section :user_search, 'div#root > div:nth-of-type(1)' do
  end
  section :user_create_update, 'div#root > div:nth-of-type(2)' do
    element :name_input, '#name'
    element :gender_input, '#gender'
    element :age_input, '#age'
    element :create_button, :button, 'Create User'
  end
  section :user_delete, 'div#root > div:nth-of-type(3)' do
  end
  section :user_list, 'div#root > div:nth-of-type(4)' do
    element :fetch_button, 'button'
    elements :user_names, 'li'
  end

  def wait_for_spinner
    wait_until_loading_spinner_visible
    wait_until_loading_spinner_invisible
  end
end