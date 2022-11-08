class BasePageScenario
    include RSpec::Matchers
    def initialize
      @page = MainPage.new
    end
  
    def create_user_with_params(user_params)
      @page.user_create_update.name_input.set user_params.name
      @page.user_create_update.gender_input.set user_params.gender
      @page.user_create_update.age_input.set user_params.age
      @page.user_create_update.create_button.click
      @page.wait_for_spinner
    end
  
    def update_user_with_params(user_params)
      @page.user_create_update.name_input.set user_params.name
      @page.user_create_update.gender_input.set user_params.gender
      @page.user_create_update.age_input.set user_params.age
      @page.user_create_update.update_button.click
      @page.wait_for_spinner
    end
  
    def search_user(name)
      @page.user_search.name_input.set name
      @page.user_search.search_button.click
      @page.wait_for_spinner
    end
  
    def delete_user(name)
      @page.user_delete.name_input.set name
      @page.user_delete.delete_button.click
      @page.wait_for_spinner
    end
  
    def click_fetch_all_users_button
      @page.user_list.fetch_button.click
      @page.wait_for_spinner
    end
  
    def check_user_list_eq(user_names)
      expect(@page.user_list.user_names.map(&:text)).to match_array(user_names)
    end
    
    def check_user_name_shown_on_page(user_name)
      expect(@page.user_search.user_params.param_item_value('Name')).to eq user_name
    end
  
    def check_user_gender_shown_on_page(user_gender)
      expect(@page.user_search.user_params.param_item_value('Gender').to_sym).to eq user_gender
    end
  
    def check_user_age_shown_on_page(user_age)
      expect(@page.user_search.user_params.param_item_value('Age').to_i).to eq user_age
    end
  
    def check_params_from_db(user)
      expect(UserFactory.get_user_from_redis(user)).to eq user
    end
  
    def check_user_existing(user)
      expect{UserFactory.get_user_from_redis(user)}.to raise_error UserNotFoundError
    end
  
    def check_error_message_on_page(message)
      expect(@page.error_message.text).to eq message
    end
  
    def check_success_message_on_page(message)
      expect(@page.success_message.text).to eq message
    end
  end
  