class Lobby < Sequel::Model
  many_to_one :player
  one_to_many :games
end
