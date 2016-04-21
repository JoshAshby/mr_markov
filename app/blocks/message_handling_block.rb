class MessageHandlingBlock < AshFrame::Block
  require :message

  publish_as 'message.handle'

  attr_internal_reader :bot
  set_callback :logic, :before, :setup_bot

  def logic
    bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
  end

  private

  def setup_bot
    config = AshFrame.config_for(:telegram).symbolize_keys
    @_bot = Telegram::Bot::Client.new config.delete(:token), logger: MrMarkov.logger, **config
  end
end
