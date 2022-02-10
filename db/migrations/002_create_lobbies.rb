Sequel.migration do
  up do
    create_table(:lobbies) do
      primary_key :id
      foreign_key :player_id, :players
      Integer :rival_id, null: false
    end
  end

  down do
    drop_tables(:lobbies)
  end
end
