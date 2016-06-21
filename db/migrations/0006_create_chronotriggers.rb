Sequel.migration do
  change do
    create_table :chronotriggers do
      primary_key :id

      String :name, null: false

      Integer :last_ran
      Integer :repeat_delta

      String :job_klass, null: false
      String :job_function, null: false
      String :job_arguments

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
