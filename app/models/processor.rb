class Processor < Sequel::Model
  plugin :validation_helpers

  many_to_one :user
  many_to_one :processor_stack

  plugin :list, scope: :processor_stack_id

  def validate
    super
  end
end
