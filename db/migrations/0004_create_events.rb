Sequel.migration do
  change do
    create_table :events do
      primary_key :id

      foreign_key :user_id, :users, index: true
      foreign_key :stack_id, :stacks, index: true
      foreign_key :frame_id, :frames, index: true

      column :event, :jsonb

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
