require 'spec_helper'
require 'uniform_invoice_lottery'

describe UniformInvoiceLottery do
  it "can check lottery" do
    expect(UniformInvoiceLottery.check('82930261', time: Time.new(2015, 7, 26)).title).to eq("特別獎")
  end
end
