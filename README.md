# lita-chatwork

A ChatWork adapter for Lita.

## Installation

Add this line to your application's Gemfile:

    gem 'lita-chatwork'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lita-chatwork

## Usage

```
# Gemfile of your lita

source "https://rubygems.org"

gem 'lita', '~> 4.1.0'
gem "lita-chatwork"
gem "chatwork"
...
```

```ruby
# lita_config.rb

Lita.configure do |config|
  config.robot.adapter = :chatwork
  config.adapters.chatwork.api_key = ENV['CHATWORK_API_KEY']
  config.adapters.chatwork.interval = 5
end
```

## Contributing

1. Fork it ( http://github.com/tokada/lita-chatwork/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
