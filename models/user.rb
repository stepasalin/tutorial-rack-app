# frozen_string_literal: true

require 'json'

class UnprocessableUserError < RuntimeError
  attr_reader :validation_errors

  def initialize(validation_errors)
    @validation_errors = validation_errors
    super
  end
end

class UserNameAlreadyTakenError < RuntimeError; end

class UserNotFoundError < RuntimeError; end

class User
  GENDERS = %i[fm m nb].freeze

  attr_reader :name, :gender, :age, :validation_errors

  def initialize(name, gender, age)
    @name = name
    @gender = gender.to_sym
    @age = age
    valid?
  end

  def valid?
    @validation_errors = []
    name_valid?
    gender_valid?
    age_valid?
    @validation_errors.empty?
  end

  def save
    raise UnprocessableUserError, @validation_errors unless valid?
    raise UserNameAlreadyTakenError if name_already_taken?

    REDIS_CONNECTION.set(@name, to_json)
  end

  def name_already_taken?
    REDIS_CONNECTION.exists? @name
  end

  def to_json(*args)
    {
      'name' => @name,
      'gender' => @gender,
      'age' => @age
    }.to_json(args)
  end

  def self.find_by_name(name)
    raw = REDIS_CONNECTION.get(name)
    raise UserNotFoundError unless raw

    json = JSON.parse(raw)
    raise UnprocessableUserError, 'invalid json scheme' unless json

    User.json_create(json)
  end

  def self.json_create(json)
    new(json['name'], json['gender'], json['age'].to_i)
  end

  def readable_age
    age = Time.at @age
    zero_time = Time.at 0
    {
      years: age.year - zero_time.year,
      months: age.month - zero_time.month,
      days: age.day - zero_time.day
    }
  end

  private

  def age_valid?
    @validation_errors << "age must be positive, actual = #{@age}" unless @age.positive?
  end

  def gender_valid?
    return if GENDERS.include?(@gender)

    @validation_errors << "unknown gender, accepted = #{GENDERS.map(&:to_s)}, actual = #{@gender}"
  end

  def name_valid?
    return if @name.length.between?(1, 30)

    @validation_errors << "name length must be between 1 and 30, actual = #{@name&.length}"
  end
end
