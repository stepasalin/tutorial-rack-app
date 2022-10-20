require_relative 'helpers/redis_helper'

class UserInvalidError < RuntimeError; end
class AccessKeyError < RuntimeError; end
class KeyUsedError < RuntimeError; end

class User
  attr_reader :name, :gender, :age, :errors

  AVAILABLE_GENDER = [:m, :f, :nb].freeze

  def initialize(user_params)
    @name = user_params["name"]
    @gender = user_params["gender"].to_sym
    @age = user_params["age"]
    @user_params = user_params

    valid?
  end

  def valid?
    @errors = []
    unless @name =~ /^[\w\d]+$/
      @errors << "Error of name symbols '#{@name}'. Accepted only leters and digits. "
    end

    unless AVAILABLE_GENDER.include?(@gender)
      @errors << "Error of gender '#{@gender}'. Correct genders are '#{:m}', '#{:f}' or '#{:nb}'. "
    end

    unless @age.is_a?(Integer) && @age.positive?
      @errors << "Error of age '#{@age}'. Age must be digits only."
    end

    @errors.empty?
  end

  def save
    if @errors.any?
      raise UserInvalidError
    elsif REDIS_CONNECTION.get(@name)
      raise AccessKeyError
    else
      REDIS_CONNECTION.set(@name, @user_params.to_json)
      @user_params.to_json
    end
  end

  def self.find(user_name)
    if !REDIS_CONNECTION.get(user_name)
      raise KeyUsedError
    else
      json_user = REDIS_CONNECTION.get(user_name)
      user_instance = User.new(JSON.parse(json_user))

      if @errors.any?
        raise UserInvalidError
      else
        user_instance
      end
    end
  end

  def to_h
    {"name"=>@name, "gender"=>@gender, "age"=>@age}
  end

  def to_json
    to_h.to_json
  end
end
