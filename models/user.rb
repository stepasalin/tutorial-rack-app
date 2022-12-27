# frozen_string_literal: true

class InvalidInputError < StandardError; end
class DuplicatedUserError < StandardError; end
class UserEntityIsNotFound < StandardError; end

class User
  attr_writer :full_info
  attr_reader :errors

  def initialize(name, age, gender)
    @name = name.downcase
    @age = age
    @gender = gender.to_sym
    @full_info = {}
    @errors = []
    valid?
  end

  def name_valid?
    @name.instance_of?(String) && @name.length.between?(1, 30) && @name.match?('^[a-zA-Z0-9]*$')
  end

  def age_valid?
    # How to deal if we have chars in integer field?
    @age.instance_of?(Integer) && @age.positive?
  end

  def gender_valid?
    %i[m f nb].include?(@gender)
  end

  def valid?
    @errors = []

    unless name_valid?
      @errors << "Invalid name. Must contain only latin alphabet characters, numbers and have length from 1 to 30 chars. No spaces allowed. \n"
    end
    @errors << "Invalid age. Must be integral number not less than 0. \n" unless age_valid?
    @errors << "Invalid gender. Must be Male, Female or Nonbinary \n" unless gender_valid?

    @errors.empty?
  end

  def name_taken?
    REDIS_CONNECTION.exists(@name) == 1
  end

  def save
    REDIS_CONNECTION.set(@name, @full_info)
  end

  def find(key)
    REDIS_CONNECTION.get(key)
  end

  def raiseFieldValidityException
    raise InvalidInputError unless valid?
  end

  def create
    raiseFieldValidityException
    raise DuplicatedUserError if name_taken?

    save
  end

  def update
    raiseFieldValidityException
    raise UserEntityIsNotFound unless name_taken?

    save
  end
end
