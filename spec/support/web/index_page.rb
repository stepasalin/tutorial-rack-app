# frozen_string_literal: true

class IndexPage < SitePrism::Page
  set_url 'http://localhost:3000/'

  section :create_section, 'div#root > div:nth-of-type(2)' do
    element :name_input, '#name'
    element :gender_input, '#gender'
    element :age_input, '#age'
    element :preloader, 'div.loading-spinner'
    element :create_user_button, :button, 'Create User'
    element :success_message, '.success'
  end

  section :read_section, 'div#root > div:nth-of-type(1)' do
    element :name_input, '#id'
    element :preloader, 'div.spinner-container'
    element :find_user_button, :button, 'Fetch User'
    element :success_message, '#root > div:nth-child(1) > div > ul'
  end
end
