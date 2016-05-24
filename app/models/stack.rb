class Stack < Sequel::Model
  plugin :validation_helpers

  many_to_one :user
  one_to_many :frames
  one_to_many :events

  def validate
    super
    validates_presence [ :name ]
  end

  def receive event
    frames.inject(event) do |memo, frame|
      event = Processors.get(frame.processor).receive frame.options, memo

      Event.create user: user, stack: self, frame: frame, event: event

      event
    end
  end
end
