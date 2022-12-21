class User

    def initialize(name, age, gender)
        @name = name.downcase
        @age = age
        @gender = gender.to_sym
        @validity_errors = []
    end
end