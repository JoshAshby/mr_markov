namespace :rabbitmq do
  desc 'Setup rabbitmq routing'
  task setup: :environment do
    ch = SpaceScrape.bunny.create_channel

    workers_exchange = ch.direct 'mr_markov.workers'
    Workers.constants.each do |c|
      const = Workers.const_get c

      next unless const.ancestors.include? Sneakers::Worker
      next unless const.queue_name
      ch.queue( const.queue_name, durable: false, auto_delete: false, arguments: { "x-max-priority" => 100 } ).bind workers_exchange, routing_key: const.routing_key
    end

    pubsub_exchange = ch.topic 'mr_markov.pubsub'
    Subscribers.constants.each do |c|
      const = Subscribers.const_get c

      next unless const.ancestors.include? Sneakers::Worker
      next unless const.queue_name
      ch.queue( const.queue_name, durable: false, auto_delete: true ).bind pubsub_exchange, routing_key: "#{ const.namespace }.#"
    end
  end
end
