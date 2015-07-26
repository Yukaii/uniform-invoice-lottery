require "uniform_invoice_lottery/version"
require "uniform_invoice_lottery/data_crawler"
require "uniform_invoice_lottery/lottery_checker"
require "uniform_invoice_lottery/exceptions"

module UniformInvoiceLottery
  ROOT_DIR = File.expand_path('..', __FILE__)
  PRICE = {
    "特別獎" => 10_000_000,
    "特獎" => 2_000_000,
    "頭獎" => 200_000,
    "二獎" => 40_000,
    "三獎" => 10_000,
    "四獎" => 4_000,
    "五獎" => 1_000,
    "六獎" => 200,
    "增開六獎" => 200,
    "下次再來，兩個月後又是一條好漢" => 0,
  }

  class << self
    def check invoice_code, opts={}
      LotteryChecker.check(invoice_code, opts)
    end
  end
end
