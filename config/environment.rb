require 'sequel'

ENV['RACK_ENV'] ||= "development"
DB_FILE = "db/games_#{ENV['RACK_ENV']}.sqlite3"
puts "database file name: #{DB_FILE}"
Sequel::Model.db = Sequel.sqlite DB_FILE

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

require 'rubygems'
require 'sinatra'
require 'pry-byebug'
require './app/games'
