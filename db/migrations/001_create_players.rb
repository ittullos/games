Sequel.migration do
  up do
    create_table(:players) do
      primary_key :id
      String :name, null: false
    end
  end

  down do
    drop_tables(:players)
  end
end
