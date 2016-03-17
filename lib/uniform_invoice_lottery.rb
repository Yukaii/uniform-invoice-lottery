module UniformInvoiceLottery
  ROOT_DIR = File.expand_path('..', __FILE__)

  require "uniform_invoice_lottery/version"
  require "uniform_invoice_lottery/support"
  require "uniform_invoice_lottery/exceptions"
  require "uniform_invoice_lottery/prizes"
  require "uniform_invoice_lottery/lottery_crawler"
  require "uniform_invoice_lottery/lottery_check_service"

  LotteryCrawler.update_lottery

  class << self
    def check invoice_code, opts={}
      LotteryCheckService.new.check(invoice_code, opts)
    end
  end
end
