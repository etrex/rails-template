require 'net/http'
require 'json'

class IndexNowService
  API_ENDPOINT = 'https://api.indexnow.org/IndexNow'.freeze

  def initialize
    @host = ENV['INDEX_NOW_HOST']
    @key = ENV['INDEX_NOW_KEY']
    @key_location = ENV['INDEX_NOW_KEY_LOCATION']
  end

  def submit_urls(urls)
    urls = [urls] if urls.is_a?(String)
    uri = URI(API_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request.body = {
      host: @host,
      key: @key,
      keyLocation: @key_location,
      urlList: urls
    }.to_json

    response = http.request(request)

    {
      status: response.code.to_i,
      body: response.body
    }
  end

  def submit_sentences(sentence_ids)
    sentence_ids = [sentence_ids] if sentence_ids.is_a?(Integer)

    urls = sentence_ids.map do |id|
      "#{@host}/sentences/zh/#{id}"
    end
    submit_urls(urls)
  end

  def submit_words(words)
    words = [words] if words.is_a?(String)

    urls = words.map do |word|
      "#{@host}/words/zh/#{word}"
    end
    submit_urls(urls)
  end
end
