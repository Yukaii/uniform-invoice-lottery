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

    def records
      LotteryCrawler.crawler.records
    end

    def find_record_by(year: nil, start_month: nil)
      record = LotteryCrawler.find_record_by(
        year: year,
        start_month: start_month,
        end_month: start_month + 1
      )

      yield(record) if block_given?

      record
    end
  end
end
