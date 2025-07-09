require 'sinatra/base'
require 'net/http'
require 'json'

class QuoteApp < Sinatra::Base
  # Disable all protection
  disable :protection
  disable :sessions
  
  # Use environment variables for deployment
  port = ENV['PORT'] || 3000
  set :bind, '0.0.0.0'
  set :port, port

  helpers do
    def fetch_random_quotes(count)
      quotes = []
      count.times do
        begin
          uri = URI('https://api.quotable.io/random')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.read_timeout = 10
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Get.new(uri)
          response = http.request(request)
          if response.code == '200'
            data = JSON.parse(response.body)
            quote_text = data['content']
            author = data['author']
            quotes << "#{quote_text} - #{author}"
          else
            quotes << "Failed to fetch quote - API Error (#{response.code})"
          end
        rescue => e
          quotes << "Failed to fetch quote - Network Error: #{e.message}"
        end
      end
      quotes
    end
  end

  get '/' do
    erb :index
  end

  post '/quotes' do
    n = params[:n].to_i
    n = 1 if n <= 0
    n = 20 if n > 20
    @quotes = fetch_random_quotes(n)
    @n = n
    erb :quotes
  end

  # Override the middleware stack
  def self.new(*args)
    app = super
    # Remove any protection middleware
    app.instance_variable_get(:@protections).clear if app.instance_variable_defined?(:@protections)
    app
  end
end

# Start the app
QuoteApp.run! 