Sequel.migration do
  up do
    create_table(:games) do
      primary_key :id
      foreign_key :lobby_id, :lobbies
      Integer :started_at, null: false
      Integer :winner_id, null: false
    end
  end

  down do
    drop_tables(:games)
  end
end
