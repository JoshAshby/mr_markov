class Event < Sequel::Model
  plugin :validation_helpers

  many_to_one :user
  many_to_one :stack
  many_to_one :frame

  def validate
    super
  end
end
