Rails.application.config.after_initialize do
  GptFunction.configure(api_key: ENV["CHATGPT_API_KEY"], model: ENV["CHATGPT_MODEL"], batch_storage: BatchStatus)
end
