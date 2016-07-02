Sequel.migration do
  change do
    create_table :stack_runs do
      primary_key :id

      foreign_key :stack_id, :stacks, index: true

      column :result, :jsonb
      String :log

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
