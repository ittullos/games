require_relative 'models/player'
require_relative 'models/lobby'
require_relative 'models/game'
require_relative 'models/play'
require 'sinatra/cookies'
require 'json'
require 'time'

class Games < Sinatra::Base

enable :sessions
set :session_secret, "here be dragons"

  get '/' do
    erb :index
  end

  get '/signup' do
    erb :signup, { :locals => params }
  end

  post '/signup' do
    Player.insert(name: "#{params[:name]}")
    @player = Player.find(name: params[:name])
    session[:player_name] = "#{@player.name}"
    session[:player_id] = "#{@player.id}"
    redirect "/account"
  end

  get '/login' do
    erb :login, { :locals => params }
  end

  post '/login' do
    @player = Player.find(name: "#{params[:name]}")
    session[:player_name] = "#{@player.name}"
    session[:player_id] = "#{@player.id}"
    redirect "/account"
  end

  get '/account' do
    @player_name = session[:player_name]
    @player_id = session[:player_id]
    erb :account
  end

  get '/create_lobby' do
    @host = Player[session[:player_id]]
    @host.add_lobby(rival_id: 0)
    @lobby = @host.lobbies.last
    session[:lobby_id] = @lobby.id
    redirect "/tictactoe?lobby_id=#{@lobby.id}&role=host"
  end

  get '/rival_refresh' do
    @lobby = Lobby[session[:lobby_id]]
    @player_id = session[:player_id]
    if(@lobby.rival_id != 0)
      @rival_refreshed = "true"
    else
      @rival_refreshed = "false"
    end
  end

  post '/game_start' do
    @payload = JSON.parse(request.body.read)
    @lobby = Lobby[@payload['lobby_id']]

    if (@payload['game_started'] == "true")
      @lobby.add_game(started_at: Time.now.to_i, winner_id: 0)
      session[:game_id] = @lobby.games.last.id
    end
  end

  get '/play_refresh' do
    @lobby = Lobby[session[:lobby_id]]
    @game = @lobby.games.last
    @play_count = @game.plays.count

    @play_info = {
      "play_number" => @play_count,
      "cell_id" => 0,
      "token" => "0"
    }

    if @play_count > 0
      @last_play = @game.plays.last
      @play_info['cell_id'] = @last_play.cell_id
      @play_info['token'] = @last_play.token
    end

    @send_data = @play_info.to_json
  end

  get '/set_state' do
    @lobby_id = session[:lobby_id]
    @game = Lobby[@lobby_id].games.last
    @player_id = session[:player_id]
     @plays = @game.plays
     if (@player_id.to_i == @plays[0].player_id)
       @player_token = "X"
     else
       @player_token = "O"
     end

    @last_token = @game.plays.last.token
    if (@last_token == "X")
      @turn = "O"
    else
      @turn = "X"
    end
    @game_board = Array.new(9, "null")
    @game.plays.each do |play|
      @game_board[play.cell_id - 1] = play.token
    end
    @state_data = {
      "game_board" => @game_board,
      "turn" => @turn,
      "player_token" => @player_token,
      "play_count" => @game.plays.count
    }.to_json
  end

  get '/game_reset' do
    @lobby = Lobby[session[:lobby_id]]
    @game = @lobby.games.last
    if (@game.plays.count == 0)
      @reset = "true"
    else
      @reset = "false"
    end
  end

  post '/winner_log' do
    @winner_info = JSON.parse(request.body.read)
    @lobby = Lobby[session[:lobby_id]]
    @player_id = session[:player_id]
    @game = @lobby.games.last
    @game.update(winner_id: @player_id.to_i)
  end

  post '/tie_log' do
    @tie_info = JSON.parse(request.body.read)
    @lobby = Lobby[session[:lobby_id]]
    @game = @lobby.games.last
    @game.update(winner_id: 1)
  end

  get '/join_lobby' do
    @open_lobbies = Lobby.where(rival_id: 0).reverse(:id)
    erb :join_lobby
  end

  get '/active_lobbies' do
    @player_id = session[:player_id]
    @active_lobbies = Lobby.where(player_id: @player_id.to_i).or(rival_id: @player_id.to_i).reverse(:id)
    erb :active_lobbies
  end

  get '/tictactoe' do
    @lobby_id = params[:lobby_id]
    session[:lobby_id] = @lobby_id

    if (params[:role] == 'rival')
      Lobby[params[:lobby_id]].update(rival_id: session[:player_id].to_i)
    end
    erb :tictactoe
  end

  post '/play_maker' do
    @play_info = JSON.parse(request.body.read.to_s)
    @game_id = Lobby[session[:lobby_id]].games.last.id
    Game[@game_id].add_play(
      player_id: session[:player_id].to_i,
      play_number: @play_info['play_number'],
      cell_id: @play_info['cell_id'].to_i,
      token: @play_info['token']
    )
  end
end
