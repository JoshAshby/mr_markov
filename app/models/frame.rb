class Frame < Sequel::Model
  include GlobalID::Identification

  plugin :validation_helpers
  plugin :list, scope: :stack_id

  many_to_one :stack
  one_to_many :results
  one_to_many :logs

  def validate
    super
    validates_presence [ :stack_id ]
  end
end
