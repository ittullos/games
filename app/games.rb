require_relative 'models/player'
require_relative 'models/lobby'
require_relative 'models/game'
require_relative 'models/play'
require 'sinatra/cookies'

class Games < Sinatra::Base

enable :sessions
set :session_secret, "here be dragons"

  get '/' do
    erb :index
  end

  get '/tictactoe' do
    erb :tictactoe
  end
end
