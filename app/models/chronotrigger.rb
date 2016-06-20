class Chronotrigger < Sequel::Model
  class << self
    def enum name
      define_singleton_method name.to_s.pluralize.to_sym do
        db.schema(table_name).to_h[name.to_sym][:enum_values].map{ |v| [ v, v ] }.to_h
      end
    end
  end

  plugin :validation_helpers

  enum :frequency_period

  def validate
    super
    validates_presence [ :name, :frequency_quantity, :frequency_period, :run_time, :job_klass ]
  end

  def frequency
    frequency_quantity.send frequency_period.to_sym
  end

  def next_run last_run
    last_run + frequency
  end
end
