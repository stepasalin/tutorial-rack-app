class A
  attr_reader :a

  def initialize(val)
    raise unless val.positive?
    @a = val
  end
end

describe A do
  let!(:int) { rand(1..10) }

  before(:all) { puts "Started at #{Time.now}" }
  before(:each) { puts '123' }
  after(:each) { puts '234' }
  after(:all) { puts "Finished at #{Time.now}" }

  it 'creates A' do
    obj = A.new(int)
    expect(obj.a).to eq(int)
  end

  it 'somethig for A' do
    obj =  A.new(int)
    expect(obj).to eq(obj)
  end

  it 'cannot create A unless arg is positive' do
    expect { A.new(0) }.to raise_error
  end
end

# expect(OBJ_A/BLCK_A).to matcher(_ARG)
# expect(A).to eq(B)
# expect { something }.to whatever