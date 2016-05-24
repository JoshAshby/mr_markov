class Result < Sequel::Model
  plugin :validation_helpers

  many_to_one :frame

  def validate
    super
    validates_presence [ :frame_id ]
  end
end
