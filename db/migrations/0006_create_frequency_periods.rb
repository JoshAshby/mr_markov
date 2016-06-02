Sequel.migration do
  change do
    create_table :frequency_periods do
      primary_key :id

      String :name

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
