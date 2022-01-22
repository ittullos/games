require 'sequel'
ENV['RACK_ENV'] = "test"

require './config/environment'
DB = Sequel::Model.db
require 'rack/test'
require 'rspec/sequel'
require 'capybara'
require 'capybara/rspec'

RSpec.configure do |c|
  c.around(:each) do |example|
    DB.transaction(:rollback=>:always, :auto_savepoint=>true){example.run}
  end
  c.include Capybara::DSL
  Capybara.app = Games
end
