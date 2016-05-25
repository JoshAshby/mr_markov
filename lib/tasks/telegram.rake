namespace :telegram do
  desc "Installs the telegram webhook"
  task install: :environment do
    bot = Telegram::Bot::Client.new ENV['TELEGRAM_TOKEN'], logger: MrMarkov.logger

    bot.api.setWebhook url: "https://mrmarkov.themoon.isin.space/hook_#{ ENV['TELEGRAM_TOKEN'] }"
    puts "Webhook installed!"
  end

  desc "Uninstalls the telegram webhook"
  task uninstall: :environment do
    bot = Telegram::Bot::Client.new ENV['TELEGRAM_TOKEN'], logger: MrMarkov.logger

    bot.api.setWebhook url: ""
    puts "Webhook uninstalled!"
  end
end
