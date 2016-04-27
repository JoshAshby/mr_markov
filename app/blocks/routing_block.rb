class RoutingBlock < AshFrame::Block
  require :message
  attr_accessor :session

  def logic
    build_session

    return if handle_command
    handle_message
  end

  def build_session
    @session = MrMarkov.cache.fetch [ message.from.id, 'session' ] do
      {
        state: nil
      }
    end
  end

  def handle_command
    command_entity = message.entities.find{ |e| e.type == "bot_command" && e.offset == 0 }

    return false unless command_entity

    length = command_entity.length

    command = message.text[0..length]
    args = message.text[length+1..-1]

    # TODO: Command Things
    MrMarkov.telegram_api.send_message chat_id: message.chat.id, text: "Hello, #{ message.from.last_name }"

    true
  end

  def handle_message
    # TODO: Message Things
    MrMarkov.telegram_api.send_message chat_id: message.chat.id, text: "Hello, #{ message.from.first_name }"

    true
  end
end
