class Stack < Sequel::Model
  include GlobalID::Identification

  plugin :validation_helpers

  many_to_one :user
  one_to_many :frames
  one_to_many :chronotriggers

  def validate
    super
    validates_presence [ :user_id, :name ]
  end
end
