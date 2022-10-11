require 'spec_helper'
require 'pry'

describe 'home page' do
  it 'welcomes the user' do
    page = MainPage.new
    visit 'http://localhost:3000/'
    binding.pry
  end
end