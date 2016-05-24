Sequel.migration do
  change do
    create_table :results do
      primary_key :id

      foreign_key :frame_id, :frames, index: true

      column :result, :jsonb

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
