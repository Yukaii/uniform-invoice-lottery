# UniformInvoiceLottery
[![Build Status](https://travis-ci.org/Yukaii/uniform-invoice-lottery.svg?branch=master)](https://travis-ci.org/Yukaii/uniform-invoice-lottery)

一個統一發票兌獎的 Gem，還有自動更新功能，還真不賴。自己說。


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uniform_invoice_lottery'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uniform_invoice_lottery

## Usage
```ruby
require 'uniform_invoice_lottery'
prize = UniformInvoiceLottery.check '82930261', time: Time.new(2015, 7, 26)
prize = UniformInvoiceLottery.check '82930261', year: 2015, month: 7 day: 26

puts prize.amount # => "10000000"
puts prize.title  # => "特別獎"
```

## Contributing

1. Fork it ( https://github.com/Yukaii/uniform_invoice_lottery/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
