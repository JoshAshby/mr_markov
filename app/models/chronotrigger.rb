class Chronotrigger < Sequel::Model
  include GlobalID::Identification

  plugin :validation_helpers

  def validate
    super
    validates_presence [ :name, :last_ran, :job_klass, :job_function ]
  end
end
