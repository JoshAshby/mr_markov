Sequel.migration do
  change do
    create_table :processors do
      primary_key :id

      foreign_key :user_id, :users, index: true
      foreign_key :processor_stack_id, :users, index: true

      integer :position

      String :processor_name
      column :options, :jsonb

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
