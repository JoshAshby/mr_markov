class Stack < Sequel::Model
  plugin :validation_helpers

  many_to_one :user
  one_to_many :frames

  def validate
    super
    validates_presence [ :user_id, :name ]
  end
end
