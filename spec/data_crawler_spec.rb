require 'spec_helper'
require 'uniform_invoice_lottery'

describe UniformInvoiceLottery do

  let(:data_crawler) {
    UniformInvoiceLottery::DataCrawler.load
    UniformInvoiceLottery::DataCrawler
   }

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
end
