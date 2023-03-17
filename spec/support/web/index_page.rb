# frozen_string_literal: true

class IndexPage < SitePrism::Page
  set_url 'http://localhost:3000/'

  section :create_and_update_section, 'div#root > div:nth-of-type(2)' do
    element :name_input, '#name'
    element :gender_input, '#gender'
    element :age_input, '#age'
    element :preloader, 'div.loading-spinner'
    element :create_user_button, :button, 'Create User'
    element :update_user_button, :button, 'Update User'
    element :success_message, '.success'
    element :error_message, 'div.error'
  end

  section :read_section, 'div#root > div:nth-of-type(1)' do
    element :name_input, '#id'
    element :preloader, 'div.loading-spinner'
    element :find_user_button, :button, 'Fetch User'
    element :success_message, '#root > div:nth-child(1) > div > ul'
    element :error_message, 'div.error'
  end

  section :delete_section, 'div#root > div:nth-of-type(3)' do
    element :name_input, '#name'
    element :delete_user_button, :button, 'Delete User'
    element :preloader, 'div.loading-spinner'
    element :success_message, 'div.success'
    element :error_message, 'div.error'
  end

  section :get_all_users_section, 'div#root > div:nth-of-type(4)' do
    element :get_users_button, :button, 'Fetch All userNames'
    element :preloader, 'div.loading-spinner'
    elements :users_list, 'ul li'
  end
end
