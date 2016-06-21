class TelegramProcessor < Processors::Base
  register_as :telegram

  setup_options do
    required :token, :chat_id

    optional message: ''
  end

  def handle
    logger.info "Sending message to #{ options[:chat_id] }"

    bot.send_message chat_id: options[:chat_id], text: options[:message]

    propagate!
  end

  protected

  def bot
    @bot ||= Telegram::Bot::Api.new options[:token]
  end
end
