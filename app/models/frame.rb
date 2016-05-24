class Frame < Sequel::Model
  plugin :validation_helpers

  many_to_one :user
  many_to_one :stack
  one_to_many :events

  plugin :list, scope: :stack_id

  def validate
    super
  end
end
