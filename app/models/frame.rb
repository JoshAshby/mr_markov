class Frame < Sequel::Model
  include GlobalID::Identification

  plugin :validation_helpers

  many_to_one :stack
  one_to_many :results
  one_to_many :logs

  plugin :list, scope: :stack_id

  def validate
    super
    validates_presence [ :stack_id ]
  end
end
