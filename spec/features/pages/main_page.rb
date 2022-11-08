require 'site_prism'

class MainPage < SitePrism::Page
  element :loading_spinner, '.spinner-container'
  element :error_message, '.error'
  element :success_message, '.success'
  section :user_search, 'div#root > div:nth-of-type(1)' do
    element :name_input, '#id'
    element :search_button, :button, 'Fetch User'
    element :error_output, ''
    section :user_params, 'ul' do
      elements :param_items, 'li'

      def find_param_item_by_name(item_name)
        param_items.find { |element| element.text.include?(item_name) }
      end

      def param_item_value(item_name)
        find_param_item_by_name(item_name).text.gsub("#{item_name}: ", '')
      end
    end
  end

  section :user_create_update, 'div#root > div:nth-of-type(2)' do
    element :name_input, '#name'
    element :gender_input, '#gender'
    element :age_input, '#age'
    element :create_button, :button, 'Create User'
    element :update_button, :button, 'Update User'
  end
  section :user_delete, 'div#root > div:nth-of-type(3)' do
    element :name_input, '#name'
    element :delete_button, :button, 'Delete User'
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