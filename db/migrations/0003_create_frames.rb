Sequel.migration do
  change do
    create_table :frames do
      primary_key :id

      foreign_key :stack_id, :stacks, index: true

      integer :position

      String :processor

      column :options, :jsonb
      column :state, :jsonb

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
