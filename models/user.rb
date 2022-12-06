require_relative '../helpers/redis_helper'

class UserInvalidError < RuntimeError; end
class AccessKeyError < RuntimeError; end
class KeyExistingdError < RuntimeError; end
class UserNameError < RuntimeError; end

class User
  attr_reader :name, :gender, :age, :errors

  AVAILABLE_GENDER = [:m, :f, :nb].freeze

  def initialize(user_params)
    @name = user_params["name"]
    @gender = user_params["gender"].to_sym
    @age = user_params["age"]

    valid?
  end


  def valid?
    @errors = []
    unless @name =~ /^[\w\d]+$/ && @name.length <= 30
      @errors << "Error of name symbols '#{@name}'. Accepted only leters and digits and not longer 30 symbols. "
    end

    unless AVAILABLE_GENDER.include?(@gender)
      @errors << "Error of gender '#{@gender}'. Correct genders are '#{:m}', '#{:f}' or '#{:nb}'. "
    end

    unless @age.is_a?(Integer) && @age.positive?
      @errors << "Error of age '#{@age}'. Age must be positive digits only."
    end

    @errors.empty?
  end


  def save
    if @errors.any?
      raise UserInvalidError
    elsif REDIS_CONNECTION.get(@name)
      raise AccessKeyError
    else
      REDIS_CONNECTION.set(@name, to_json)
      to_json
    end
  end


  def self.find(user_name)
    raise KeyExistingdError if !REDIS_CONNECTION.get(user_name)

    json_user = REDIS_CONNECTION.get(user_name)
    user_instance = User.new(JSON.parse(json_user))

    raise UserInvalidError if user_instance.errors.any?

    user_instance
  end


  def self.delete(user_name)
    user_to_be_deleted = REDIS_CONNECTION.get(user_name)
    raise KeyExistingdError if !user_to_be_deleted

    REDIS_CONNECTION.del(user_name)
    user_to_be_deleted
  end


  def update(user_name)
    if !REDIS_CONNECTION.get(user_name)
      raise KeyExistingdError
    elsif user_name != @name
      raise UserNameError
    elsif @errors.any?
      raise UserInvalidError
    else
      REDIS_CONNECTION.set(user_name, to_json)
      to_json
    end
  end


  def to_h
    {"name"=>@name, "gender"=>@gender, "age"=>@age}
  end


  def to_json
    to_h.to_json
  end


  def ==(other)
    @age == other.age && @gender == other.gender && @name == other.name
  end
end