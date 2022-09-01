class User
  attr_reader :name, :gender, :age, :data

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

  def validator
    @errors << 'The name must be a string from 1 to 30 characters' if @name.empty? || @name.length > 30
    @errors << 'Gender must be :m, :f or :nb' unless [':m', ':f', ':nb'].include?(@gen) # TODO ПОЧИТАТЬ ПРО INCLUDE СДЕЛАТЬ МАССИС И СРАВНИВАТЬ прогнать рубокоп
    @errors << 'Age must be > 0' unless @age.positive?
  end

  def time_convert
    time = @age
    time = time / 60 / 60 / 24
    days = time % 30
    time /= 30
    months = time % 12
    time /= 12
    years = time
    [years, months, days]
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

  def user_get
    raise ArgumentsError.new, "Bad data from database: #{@errors}" if @errors.any?

    case @gen
    when ':m'
      bgcolor = 'blue'
    when ':f'
      bgcolor = 'pink'
    when ':nb'
      bgcolor = 'gray'
    end
    age_readable = time_convert
    @data = %(<html>
      <body bgcolor = #{bgcolor}>
      <h1>#{@name}</h1>
      <p>#{age_readable[0]} years, #{age_readable[1]} months, #{age_readable[2]} days</p>
      </body>
      </html>)
  end
end