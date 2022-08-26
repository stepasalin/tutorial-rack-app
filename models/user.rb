# frozen_string_literal: true

require 'json'

class UnprocessableUserError < RuntimeError; end

class UserNameAlreadyTakenError < RuntimeError; end

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
    raise UnprocessableUserError unless valid?
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

  # fixme?
  def self.find_by_name(name)
    raw = REDIS_CONNECTION.get(name)
    return nil if raw.nil? # not found error?

    json = JSON.parse(raw)
    return nil if json.nil? # not found error?

    User.json_create(json)
  end

  def self.json_create(json)
    puts json
    new(json['name'], json['gender'], json['age'].to_i)
  end

  private

  def age_valid?
    @validation_errors << "age must be positive, actual = #{@age}" unless @age&.positive?
  end

  def gender_valid?
    unless GENDERS.include?(@gender)
      @validation_errors << "unknown gender, accepted = #{GENDERS.map(&:to_s)}, actual = #{@gender}"
    end
  end

  def name_valid?
    unless @name&.length&.between?(1, 30)
      @validation_errors << "name length must be between 1 and 30, actual = #{@name&.length}"
    end
  end
end
