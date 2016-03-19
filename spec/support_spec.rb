require 'spec_helper'
require 'uniform_invoice_lottery/support'
require 'uniform_invoice_lottery/exceptions'

describe UniformInvoiceLottery::Support do
  before do
    @object = Object.new
    @object.extend(UniformInvoiceLottery::Support)
  end

  it "should calculate correct lottery month" do
    expect( @object.get_draw_month( Time.new(2015, 1, 15) )).to eq(11)
    expect( @object.get_draw_month( Time.new(2015, 1, 25) )).to eq( 1)
    expect( @object.get_draw_month( Time.new(2015, 2, 28) )).to eq( 1)

    expect( @object.get_lottery_months(3)).to eq([1,2])
    expect( @object.get_lottery_months(1)).to eq([11,12])
    # 奇數月開獎的說
    expect{  @object.get_lottery_months(2) }.to raise_error(UniformInvoiceLottery::InvalidLotteryMonthError)
  end
end
