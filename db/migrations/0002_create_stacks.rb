Sequel.migration do
  change do
    create_table :stacks do
      primary_key :id

      foreign_key :user_id, :users, index: true

      String :name

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
