require_relative '../../app.rb'

describe 'API' do
  let(:app) { Application.new }

  it 'creates User' do
    env = {
      'REQUEST_PATH' => '/user/new',
      'PATH_INFO'=> '/user/new',
      'REQUEST_METHOD' => 'POST',
      'rack.input' => StringIO.new('{"name": "Kolya23","gender": "m","age": 90000}')
    }
    response = app.call(env)
    expect(response).to eq([201,{},['new user is created!']])
  end
end