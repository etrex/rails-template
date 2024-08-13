Slack.configure do |config|
  config.token = ENV["SLACK_BOT_TOKEN"]
end

# Slack.send_message(message: 'test', channel: 'test')
module Slack
  def self.send_message(channel: ENV["SLACK_CHANNEL"], message: 'test')
    try_to_send(channel: channel, message: message)
  rescue
    puts "Slack.send(#{channel}, #{message}) 壞了"
  end

  def self.try_to_send(channel:, message:)
    client = Slack::Web::Client.new
    client.chat_postMessage(channel: "##{channel}", text: message, as_user: true)
  rescue Exception => e
    # 當 channel 不存在的時候會到這裡，嘗試發錯誤訊息到 debug channel
    debug_channel = ENV["SLACK_DEBUG_CHANNEL"]
    error_message = "嘗試 Slack.send(#{channel}, #{message})\n但發生錯誤：#{e.message}"
    client.chat_postMessage(channel: "##{debug_channel}", text: error_message, as_user: true)
  end
end
