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
end
