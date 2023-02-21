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

  def self.defined_age(name: nil, age: nil, gender: nil)
    ages = [1_000_000, 2_000_000, 4_000_000, 10_000_000, 1_000_000_000, 2_000_000_000, 555_555_555, 1_234_567_890, 1,
            65_464_654]
    user = create(name: name, age: ages.sample, gender: gender)
    user.save
    user
  end

  def self.years(age)
    years = { 1_000_000 => 0,
      2_000_000 => 0,
      4_000_000 => 0,
      10_000_000 => 0,
      1_000_000_000 => 31,
      2_000_000_000 => 63,
      555_555_555 => 17,
      1_234_567_890 => 39,
      1 => 0,
      65_464_654 => 2 }
      years[age]
  end

  def self.months(age)
    months = { 1_000_000 => 0,
      2_000_000 => 0,
      4_000_000 => 1,
      10_000_000 => 3,
      1_000_000_000 => 8,
      2_000_000_000 => 4,
      555_555_555 => 7,
      1_234_567_890 => 1,
      1 => 0,
      65_464_654 => 0 }
      months[age]
  end

  def self.days(age)
    days = { 1_000_000 => 11,
      2_000_000 => 23,
      4_000_000 => 15,
      10_000_000 => 25,
      1_000_000_000 => 8,
      2_000_000_000 => 17,
      555_555_555 => 9,
      1_234_567_890 => 13,
      1 => 0,
      65_464_654 => 27 }
      days[age]
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
