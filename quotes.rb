require 'net/http'
require 'json'

def fetch_random_quotes(count)
  quotes = []
  
  count.times do
    begin
      # Using Quotable API to get random quotes
      uri = URI('https://api.quotable.io/random')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 10
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE  # Disable SSL verification for demo
      
      request = Net::HTTP::Get.new(uri)
      response = http.request(request)
      
      if response.code == '200'
        data = JSON.parse(response.body)
        quote_text = data['content']
        author = data['author']
        quotes << "#{quote_text} - #{author}"
      else
        # Fallback to a simpler API
        fallback_uri = URI('http://quotes.rest/qod.json')
        fallback_http = Net::HTTP.new(fallback_uri.host, fallback_uri.port)
        fallback_http.read_timeout = 10
        
        fallback_request = Net::HTTP::Get.new(fallback_uri)
        fallback_response = fallback_http.request(fallback_request)
        
        if fallback_response.code == '200'
          fallback_data = JSON.parse(fallback_response.body)
          if fallback_data['contents'] && fallback_data['contents']['quotes']
            quote = fallback_data['contents']['quotes'][0]
            quotes << "#{quote['quote']} - #{quote['author']}"
          else
            quotes << "Failed to fetch quote - No data available"
          end
        else
          quotes << "Failed to fetch quote - API Error (#{response.code})"
        end
      end
    rescue => e
      quotes << "Failed to fetch quote - Network Error: #{e.message}"
    end
  end
  
  quotes
end

puts "Random Quote Generator (Internet Edition)"
puts "=" * 45

print "Enter the number of quotes you want (N): "
n = gets.chomp.to_i

# Validate input
if n <= 0
  puts "Please enter a positive number."
  exit
elsif n > 20
  puts "That's a lot of quotes! I'll limit it to 20 for performance."
  n = 20
end

puts "\nFetching #{n} random quote(s) from the internet..."
puts "-" * 50

# Fetch random quotes from internet
quotes = fetch_random_quotes(n)

quotes.each_with_index do |quote, index|
  puts "#{index + 1}. #{quote}"
end

puts "\nEnjoy your quotes! 📚✨"
puts "Powered by Quotable API" 