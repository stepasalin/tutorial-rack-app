# frozen_string_literal: true

class User
  def initialize(name, age, gender)
    @name = name.downcase
    @age = age
    @gender = gender.to_sym
    @validity_errors = []
    check_user_input_validity
  end

  def name_valid?
    @name.instance_of?(String) && @name.length.between?(1, 30) && @name.match?('^[a-zA-Z0-9]*$')
  end

  def age_valid?
    @age.instance_of?(Integer) && @age.positive?
  end

  def gender_valid?
    %i[m f nb].include?(@gender)
  end

  def check_user_input_validity
    unless name_valid?
      @validity_errors << "Invalid name. Must contain only latin alphabet characters, numbers and have length from 1 to 30 chars. No spaces allowed \n"
    end
    @validity_errors << "Invalid age. Must be integral number not less than 0. \n" unless age_valid?
    @validity_errors << "Invalid gender. Must be Male, Female or Nonbinary \n" unless gender_valid?
    return true if @validity_errors.empty?

    false
  end
end
