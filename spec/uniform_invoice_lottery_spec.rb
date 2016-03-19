require 'spec_helper'
require 'uniform_invoice_lottery'

describe UniformInvoiceLottery do
  it "can check lottery" do
    special_prize = UniformInvoiceLottery.check('82930261', time: Time.new(2015, 7, 26))
    expect(special_prize.title).to eq("特別獎")
    expect(special_prize.amount).to eq(10_000_000)
    expect(special_prize.to_s).to eq("特別獎: NT$ 10000000")
  end

  it 'should load records' do
    records = UniformInvoiceLottery.records

    expect(records.class).to eq(Array)

    unless records.empty?
      expect(records.first.class).to eq(Hash)
      %w(year start_month end_month special_prize grand_prize first_prizes additional_sixth_prizes).each {|k|
        expect(records.first).to have_key(k)
      }
    end
  end

  it 'can find record by year and start_month' do
    _r = {
      'year' => 104,
      'start_month' => 1,
      'end_month' => 2,
      'special_prize' => '60538935',
      'grand_prize' => '50887710',
      'first_prizes' => [
        '63856949',
        '39459262',
        '61944942',
      ],
      'additional_sixth_prizes' => [
        '022',
        '355',
        '038',
      ]
    }
    expect(UniformInvoiceLottery.find_record_by(year: 104, start_month: 1)).to eq(_r)

    UniformInvoiceLottery.find_record_by(year: 104, start_month: 1) do |record|
      expect(record).not_to be_nil
    end
  end
end
