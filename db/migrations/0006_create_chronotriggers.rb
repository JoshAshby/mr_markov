Sequel.migration do
  change do
    create_table :chronotriggers do
      primary_key :id

      String :name, null: false

      column :last_ran, :date
      column :run_at,   :time

      bit      :day_mask, size: 7
      interval :repeat

      String :job_klass, null: false
      String :job_function, null: false
      String :job_arguments

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
