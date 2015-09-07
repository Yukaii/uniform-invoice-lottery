# UniformInvoiceLottery

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

回傳號碼結果字串，例如：
```ruby
require 'uniform_invoice_lottery'
UniformInvoiceLottery.check '82930261', time: Time.new(2015, 7, 26)
```

嫌太長就這樣寫

```ruby
uni_invoice = UniformInvoiceLottery
uni_invoice.check '82930261', time: Time.new(2015, 7, 26)
```

上面這段回傳 `"特別獎"`。


總共有這幾個回傳值：

    特別獎
    特獎
    頭獎
    二獎
    三獎
    四獎
    五獎
    六獎
    增開六獎
    下次再來，兩個月後又是一條好漢

XD。

## Contributing

1. Fork it ( https://github.com/Yukaii/uniform_invoice_lottery/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
