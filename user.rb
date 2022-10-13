class User
  attr_reader :name, :gender, :errors
  attr_accessor :age

  AVAILABLE_GENDER = [:m, :f, :nb].freeze

  def initialize(user)
    @name = user["name"]
    @gender = user["gender"].to_sym
    @age = user["age"]

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
end
