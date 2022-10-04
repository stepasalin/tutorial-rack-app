def gen_random_string(of_length: 1, to_length: 30)
  [*'a'..'z', *0..9, *'A'..'Z'].shuffle[1..rand(of_length..to_length)].join
end

def gen_random_gender
  gen = %w[fm m nb]
  gen.sample
end

def gen_random_age
  rand(315576000..3155760000)
end