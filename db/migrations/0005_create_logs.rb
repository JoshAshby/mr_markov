Sequel.migration do
  change do
    create_table :logs do
      primary_key :id

      foreign_key :frame_id, :frames, index: true

      String :log

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
