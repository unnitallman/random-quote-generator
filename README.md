# Random Quote Generator

A simple Sinatra web application that generates random quotes from the Quotable API.

## Features

- Web interface to request N random quotes (1-20)
- Fetches quotes from the Quotable API
- Clean, responsive design
- Error handling for network issues

## Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```

## Usage

1. Start the server:
   ```bash
   ruby app.rb
   ```

2. Open your browser and go to `http://localhost:4567`

3. Enter the number of quotes you want (1-20) and click "Get Quotes"

## Dependencies

- Sinatra
- JSON
- Net::HTTP (built-in)

## API

The app uses the [Quotable API](https://github.com/lukePeavey/quotable) to fetch random quotes.

## License

MIT License
