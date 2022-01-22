require 'spec_helper'

RSpec.describe Games do
  include Rack::Test::Methods

  def app
    Games
  end

  describe 'Homepage - ' do
    context "Content - " do
      it "loads the header" do
        visit('/')
        expect(page).to have_content('GAMES')
        expect(page).to have_content('Tic Tac Toe')
      end
      it "loads links" do
        visit('/')
        expect(page).to have_link('Tic Tac Toe')
      end
    end
  end

  describe 'Database - ' do
    before do
      Player.insert(name: 'Steve')
      @player = Player.first
      @player.add_lobby(rival_id: 2, wins: 27, ties: 12, losses: 4)

      @lobby = @player.lobbies.first
      @lobby.add_game(started_at: 212, winner_id: 1)

      @game = @lobby.games.first
      @game.add_play(player_id: 1, play_number: 1, cell_id: 9, token: 'X')

      @play = @game.plays.first
    end

    context "Players table" do
      it "stores a new player" do
        expect(@player.name).to eq('Steve')
      end
    end
    context "Lobbies table" do
      it "stores a new lobby" do
        expect(@lobby.ties).to eq(12)
      end
    end
    context "Games table" do
      it "stores a new player" do
        expect(@game.started_at).to eq(212)
      end
    end
    context "Plays table" do
      it "stores a new play" do
        expect(@play.token).to eq('X')
      end
    end
  end
end
