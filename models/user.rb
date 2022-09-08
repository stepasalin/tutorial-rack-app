class User
  attr_reader :name, :gen, :age, :errors

  def initialize(pars)
    @name = pars['name'].to_s
    @gen = pars['gender']
    @age = pars['age'].to_i
    @errors = []

    validator
  end

  def self.new_from_redis(name)
    raise ExistingError.new, "Name doesn't exist" unless REDIS_CONNECTION.exists?(name)

    pars = REDIS_CONNECTION.get(name)
    new(JSON.parse(pars))
  end

  def self.delete_from_redis(name)
    raise ExistingError.new, "Name doesn't exists" unless REDIS_CONNECTION.exists?(name)

    REDIS_CONNECTION.del(name)
  end

  def validator
    @errors << 'The name must be a string from 1 to 30 characters' if @name.empty? || @name.length > 30
    @errors << 'Gender must be :m, :f or :nb' unless %w[:m :f :nb].include?(@gen)
    @errors << 'Age must be > 0' unless @age.positive?
  end

  def to_json
    hash = {}
    hash['name'] = @name
    hash['gender'] = @gen
    hash['age'] = @age
    hash.to_json
  end

  def save
    raise ArgumentsError.new, "Wrong arguments: #{@errors}" if @errors.any?
    raise ExistingError.new, 'Name exists' if REDIS_CONNECTION.exists?(@name)

    REDIS_CONNECTION.set(@name, to_json)
  end

  def update_record_in_redis
    raise ArgumentsError.new, "Wrong arguments: #{@errors}" if @errors.any?
    raise ExistingError.new, "Name doesn't exists" unless REDIS_CONNECTION.exists?(@name)

    REDIS_CONNECTION.getset(@name, to_json)
  end
end
