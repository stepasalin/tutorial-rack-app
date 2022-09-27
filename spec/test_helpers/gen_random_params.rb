def gen_random_string(str_length)
  [*'a'..'z', *0..9, *'A'..'Z'].shuffle[1..rand(1..str_length)].join
end

def gen_random_gender # TODO брать один рандомный
  gen = %w[fm m nb]
  gen[rand(gen.length)] # TODO найти метод вместо rand()
end

def gen_random_age
  rand(315576000..3155760000)
end