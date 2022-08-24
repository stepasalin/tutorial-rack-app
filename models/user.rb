# frozen_string_literal: true

require 'json'

class UnprocessableUserError < RuntimeError; end

class UserNameAlreadyTakenError < RuntimeError; end

class User
  GENDERS = %i[fm m nb].freeze

  attr_reader :name, :gender, :age, :validation_errors

  def initialize(name, gender, age)
    @name = name
    @gender = gender
    @age = age
    valid?
  end

  def valid?
    @validation_errors = []
    @validation_errors << 'name length must be between 1 and 30' unless @name&.length&.between? 1, 30
    @validation_errors << 'unknown gender' unless GENDERS.include? @gender.to_sym
    @validation_errors << 'age must be positive' unless @age&.positive?
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
    json = REDIS_CONNECTION.get(name)
    return nil if json.nil?
    User.json_create(json)
  end

  def self.json_create(json)
    new(json['name'], json['gender'], json['age'])
  end
end
