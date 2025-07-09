require 'sinatra'
require 'net/http'
require 'json'

set :bind, '0.0.0.0'
set :port, 3000
set :protection, :except => [:frame_options]
disable :protection

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

__END__

@@layout
<!DOCTYPE html>
<html>
<head>
  <title>Random Quote Generator</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 2em; background: #f9f9f9; }
    .container { max-width: 600px; margin: auto; background: #fff; padding: 2em; border-radius: 8px; box-shadow: 0 2px 8px #ccc; }
    h1 { color: #333; }
    form { margin-bottom: 2em; }
    input[type=number] { width: 60px; padding: 0.3em; }
    .quote { margin: 1em 0; padding: 1em; background: #f0f0f0; border-left: 4px solid #0074D9; }
    .author { font-style: italic; color: #555; }
  </style>
</head>
<body>
  <div class="container">
    <%= yield %>
    <footer style="margin-top:2em; color:#aaa; font-size:0.9em;">Powered by Quotable API</footer>
  </div>
</body>
</html>

@@index
<h1>Random Quote Generator</h1>
<form action="/quotes" method="post">
  <label for="n">How many quotes do you want? (1-20):</label>
  <input type="number" id="n" name="n" min="1" max="20" value="3" required>
  <button type="submit">Get Quotes</button>
</form>

@@quotes
<h1>Here are your <%= @n %> random quote(s):</h1>
<% @quotes.each_with_index do |quote, i| %>
  <div class="quote">
    <%= i+1 %>. <%= quote.split(' - ')[0] %><br>
    <span class="author">- <%= quote.split(' - ')[1] %></span>
  </div>
<% end %>
<a href="/">&#8592; Get more quotes</a> 