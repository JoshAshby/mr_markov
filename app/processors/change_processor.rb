class ChangeProcessor < Processors::Base
  register_as :change

  setup_options do
    required :from

    optional on_change: {},
             on_same: {}
  end

  def handle
    current = shaify options[:from]

    last = state['last']

    logger.debug "Previous value: #{ last }"
    logger.debug "Current value: #{ current }"

    return cancel! options[:on_same] unless current != last

    state['last'] = current

    propagate! options[:on_change]
  end

  protected

  def shaify evt
    event_dup = evt.clone

    hashable_data = JSON.dump event_dup
    digest = Digest::SHA2.new << hashable_data

    digest.to_s
  end
end
