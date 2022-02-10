require 'spec_helper'

RSpec.describe Games do
  include Rack::Test::Methods

  def app
    Games
  end

  describe '- Database -' do
    before do
      Player.insert(name: 'Steve')
      @player = Player.find(name: 'Steve')
      @player.add_lobby(rival_id: 2)

      @lobby = @player.lobbies.first
      @lobby.add_game(started_at: 212, winner_id: 1)

      @game = @lobby.games.first
      @game.add_play(player_id: 1, play_number: 1, cell_id: 9, token: 'X')

      @play = @game.plays.first
    end

    context 'Players table' do
      it 'stores a new player' do
        expect(@player.name).to eq('Steve')
      end
    end
    context 'Lobbies table' do
      it 'stores a new lobby' do
        expect(@lobby.rival_id).to eq(2)
      end
    end
    context 'Games table' do
      it 'stores a new player' do
        expect(@game.started_at).to eq(212)
      end
    end
    context 'Plays table' do
      it 'stores a new play' do
        expect(@play.token).to eq('X')
      end
    end
  end

  describe '- Homepage -' do
    before do
      visit('/')
    end
    context 'Content' do
      it 'has header' do
        expect(page).to have_text('GAMES')
      end
      it 'loads links' do
        expect(page).to have_link('Tic Tac Toe')
      end
    end
  end

  describe '- Player creation -' do
    before do
      visit('/signup')
    end
    context 'Content' do
      it 'has account creation message' do
        expect(page).to have_text("Please enter a username to create an account")
      end
      it 'has username form' do
        expect(page).to have_css('form')
      end
    end
    context 'Form input' do
      it 'creates a new player' do
        fill_in('Username', with: "Isaac")
        click_on 'submitBtn'
        @player = Player.find(name: "Isaac")
        expect(@player.name).to eq('Isaac')
        expect(page).to have_text("Hello Isaac")
      end
    end
  end

  describe '- Player login -' do
    before do
      Player.insert(name: "Douglas")
      visit('/login')
    end
    context 'Content' do
      it 'has login message' do
        expect(page).to have_text("Please enter your username to login")
      end
      it 'has login form' do
        expect(page).to have_css('form')
      end
    end
    context 'Form input' do
      it 'finds player account' do
        fill_in('Username', with: "Douglas")
        click_on 'submitBtn'
        @player = Player.find(name: "Douglas")
        expect(@player.name).to eq('Douglas')
        expect(page).to have_text("Hello Douglas")
      end
    end
  end

  before do
    Player.insert(name: "Bruce")
    @host = Player.find(name: "Bruce")
    Player.insert(name: "Eric")
    @rival = Player.find(name: "Eric")
  end

  xdescribe '- Lobby Creation -' do
    before do
      visit('/')
      click_on 'Make a new game lobby'
    end
    it 'stores lobby id and shows it to the host' do
      expect(@host.lobbies.first.id).to eq(1)
      expect(page).to have_text("Your lobby ID is #{@host.lobbies.first.id}")
    end
  end

  describe '- Routes -' do
    context '- GET -' do
      it 'Homepage' do
        get '/'
        expect(last_response.status).to eq(200)
      end
      it 'Signup' do
        get '/signup'
        expect(last_response.status).to eq(200)
      end
      it 'Login' do
        get '/login'
        expect(last_response.status).to eq(200)
      end
      it 'Account' do
        get '/account'
        expect(last_response.status).to eq(200)
      end
      xit 'Create lobby' do
        get '/create_lobby'
        expect(last_response.status).to eq(200)
      end
    end
  end
end
