require 'spec_helper'
require 'uniform_invoice_lottery'

describe UniformInvoiceLottery do

  let(:data_crawler) {
    UniformInvoiceLottery::DataCrawler
  }

  describe "test DataCrawler module" do
    it "should have DataCrawler sub module" do
      records = data_crawler.records

      expect(records.class).to eq(Array)

      unless records.empty?
        expect(records.first.class).to eq(Hash)
        %w(year start_month end_month so_special_price special_price head_prices additional_sixth_prices).each {|k|
          expect(records.first).to have_key(k)
        }
      end
    end

    it "should calculate correct lottery month" do
      expect(data_crawler.get_draw_month( Time.new(2015, 1, 15) )).to eq(11)
      expect(data_crawler.get_draw_month( Time.new(2015, 1, 25) )).to eq( 1)
      expect(data_crawler.get_draw_month( Time.new(2015, 2, 28) )).to eq( 1)

      expect(data_crawler.send(:get_lottery_months, 3)).to eq([1,2])
      expect(data_crawler.send(:get_lottery_months, 1)).to eq([11,12])
      # 奇數月開獎的說
      expect{ data_crawler.send(:get_lottery_months, 2) }.to raise_error(UniformInvoiceLottery::InvalidLotteryMonthError)
    end
  end

end
