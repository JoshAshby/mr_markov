class Chronotrigger < Sequel::Model
  include GlobalID::Identification

  plugin :validation_helpers

  def validate
    super
    validates_presence [ :name, :job_klass, :job_function ]
  end
end
