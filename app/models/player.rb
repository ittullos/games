class Player < Sequel::Model
  one_to_many :lobbies
  one_to_many :plays
end
