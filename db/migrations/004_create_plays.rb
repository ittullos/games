Sequel.migration do
  up do
    create_table(:plays) do
      primary_key :id
      foreign_key :game_id, :games
      foreign_key :player_id, :players
      Integer :play_number, null: false
      Integer :cell_id, null: false
      String :token, null: false
    end
  end

  down do
    drop_tables(:plays)
  end
end
