Sequel.migration do
  change do
    create_table :processor_stacks do
      primary_key :id

      foreign_key :user_id, :users, index: true
      String :name

      column :options, :jsonb
      column :state, :jsonb

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
