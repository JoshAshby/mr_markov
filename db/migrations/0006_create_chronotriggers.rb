Sequel.migration do
  change do
    create_enum :frequency_periods, %w|minutes hours days weeks months|

    create_table :chronotriggers do
      primary_key :id

      String :name, null: false

      # When to repeat. Things like: 1 week, 2 days, 5 months
      Integer :frequency_quantity, null: false
      frequency_periods :frequency_period, null: false, index: true, default: 'minutes'

      # time of day, in UTC that this task should run at.
      Time :run_time, null: false

      String :job_klass, null: false
      String :job_arguments

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
