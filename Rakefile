require './config/environment'

namespace :db do
  desc "Run Migrations"
  task :migrate, [:version] do |t, args|
    require "sequel/core"
    Sequel.extension :migration
    version = args[:version].to_i if args[:vesion]
    puts "migrating: #{DB_FILE}"
    Sequel.sqlite(DB_FILE) do |db|
      Sequel::Migrator.run(db, "db/migrations", target: version)
    end
  end
  desc "Seed Database"
  task :seed do
    Player.insert(name: "jim")
    Player.insert(name: "john")
    @player = Player.find(name: "jim")
    @player.add_lobby(rival_id: 2, wins: 0, ties: 0, losses: 0)
    @lobby = @player.lobbies.first
    @lobby.add_game(started_at: 212, winner_id: 0)
    @game = @lobby.games.first
    @game.add_play(player_id: 1, play_number: 1, cell_id: 1, token: 'X')
    @game.add_play(player_id: 2, play_number: 2, cell_id: 2, token: '0')
    @game.add_play(player_id: 1, play_number: 3, cell_id: 3, token: 'X')


  end
end
