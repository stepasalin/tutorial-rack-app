# почитать rspec cheat sheet
require 'pry'

class Something
  def plus(number)
    number + 1
  end
end

describe Something do
  let(:obj) { Something.new }
  let(:input) { rand(1..10) }
  
  context 'adding' do
    before(:all) { puts 'before all' }
    before(:example) { puts 'before example' }
    after(:all) { puts 'after all' }
    after(:example) { puts 'after example'}

    it 'adds 1' do
      expect(obj.plus(input)).to eq input + 1
    end

    it 'does not add 2' do
      expect(obj.plus(input)).not_to eq input + 2
    end
  end

  context 'substracting' do
  end
end