Sequel.migration do
  change do
    create_enum :frequency_periods, %w|seconds, minutes, hours, days, weeks, months|

    create_table :chrono_triggers do
      primary_key :id

      Integer :frequency_quantity
      frequency_periods :frequency_period, index: true, default: 'info'

      String :name
      String :at

      String :if_string

      String :job_name
      jsonb :job_arguments

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
