class ChangeProcessor < Processors::Base
  register_as :change

  setup_options do
    required :from
  end

  def handle
    current = shaify options[:from]

    last = state['last']

    return cancel! unless current != last

    state['last'] = current

    propagate! event
  end

  protected

  def shaify evt
    event_dup = evt.clone

    hashable_data = JSON.dump event_dup
    digest = Digest::SHA2.new << hashable_data

    digest.to_s
  end
end
