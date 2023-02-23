# frozen_string_literal: true

class InvalidInputError < StandardError; end
class DuplicatedUserError < StandardError; end
class UserEntityIsNotFound < StandardError; end

class User
  attr_reader :errors, :name, :gender, :age

  def initialize(body)
    @name = body['name'].downcase
    @age = body['age'].to_i
    @gender = body['gender'].to_sym
    @errors = []
    valid?
  end

  def to_hash
    { 'name' => @name, 'age' => @age, 'gender' => @gender }
  end

  def to_json(*_args)
    to_hash.to_json
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

  def valid?
    @errors = []

    unless name_valid?
      @errors << "Invalid name. Must contain only latin alphabet characters, numbers and have length from 1 to 30 chars. No spaces allowed. \n"
    end
    @errors << "Invalid age. Must be integral number not less than 0. \n" unless age_valid?
    @errors << "Invalid gender. Must be Male, Female or Nonbinary \n" unless gender_valid?

    @errors.empty?
  end

  def self.find(name)
    raise UserEntityIsNotFound unless REDIS_CONNECTION.get(name)

    User.new(JSON.parse(REDIS_CONNECTION.get(name)))
  end

  def save
    REDIS_CONNECTION.set(@name, to_json)
  end

  def exists?
    REDIS_CONNECTION.exists(@name) == 1
  end

  def create
    raise InvalidInputError unless valid?
    raise DuplicatedUserError if exists?

    save
  end

  def overwrite
    raise InvalidInputError unless valid?
    raise UserEntityIsNotFound unless exists?

    save
  end

  def self.delete(name)
    raise UserEntityIsNotFound unless REDIS_CONNECTION.get(name)

    REDIS_CONNECTION.del(name)
  end

  def self.list
    REDIS_CONNECTION.keys('*')
  end

  def self.delete_all
    REDIS_CONNECTION.flushdb
  end
end
