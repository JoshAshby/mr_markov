Sequel.migration do
  change do
    create_table :chronotriggers do
      primary_key :id

      foreign_key :stack_id, :stacks, index: true

      String :name, null: false

      column :last_ran, :date
      column :run_at,   :time, null: false, index: true

      String :timezone, null: false, default: 'Etc/UTC'

      bit      :day_mask, size: 7, default: '0000000'
      Integer  :repeat,            default: 0

      column :event, :jsonb
      # String :job_klass, null: false
      # String :job_function, null: false
      # String :job_arguments

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
