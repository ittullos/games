class Game < Sequel::Model
  many_to_one :lobby
  one_to_many :plays
end
