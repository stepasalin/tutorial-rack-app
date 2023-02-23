# frozen_string_literal: true

require 'securerandom'
require_relative '../../../models/user'

class TestUser
  attr_writer :age

  def self.create(name: nil, age: nil, gender: nil)
    name ||= SecureRandom.alphanumeric(10).downcase
    gender ||= %w[m f nb].sample
    age ||= rand(1..1_000_000_000_000)
    body = { 'name' => name, 'gender' => gender, 'age' => age }
    User.new(body)
  end

  def self.save(name: nil, age: nil, gender: nil)
    user = create(name: name, age: age, gender: gender)
    user.save
    user
  end

  def self.invalid_name(name: nil, age: nil, gender: nil)
    border_longname = SecureRandom.alphanumeric(31)
    longname = SecureRandom.alphanumeric(rand(32..1000))
    names = [longname, border_longname, '', ' ']
    create(name: names.sample, age: age, gender: gender)
  end

  def self.invalid_age(name: nil, age: nil, gender: nil)
    negative_num = rand(-1_000_000_000..-1)
    char = ('a'..'z').to_a.sample
    ages = [negative_num, char]
    # ' ', 0, -1, '', 0.01, -0, 0o1
    create(name: name, age: ages.sample, gender: gender)
  end

  def self.invalid_gender(name: nil, age: nil, gender: nil)
    char = ('a'..'z').to_a - %w[f m]
    create(name: name, age: age, gender: char.sample)
  end
end
