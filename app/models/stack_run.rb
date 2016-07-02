class StackRun < Sequel::Model
  include GlobalID::Identification

  plugin :validation_helpers

  many_to_one :stack

  def validate
    super
    validates_presence [ :stack_id ]
  end
end
