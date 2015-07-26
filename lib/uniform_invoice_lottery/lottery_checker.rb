module UniformInvoiceLottery
module LotteryChecker
  class << self
    def check invoice_code, opts={}

      # option handling
      if opts.is_a? Hash
        options = %i(time year month day)
        opts = Hash[opts.map{|k, v| [k.to_sym, v]}]

        # white list =w=
        opts = Hash[options.zip(opts.values_at(*options))]

        opts.each{|k, v| instance_variable_set("@#{k}", v) }
      end

      @time ||= Time.new(@year, @month, @day) if @year && @month && @day
      @time ||= Time.now

      @start_month, @end_month = DataCrawler.get_lottery_months(DataCrawler.get_draw_month(@time))

      record = DataCrawler.records.find{|rec| rec["year"] == @time.year-1911 && rec["start_month"] == @start_month && rec["end_month"] == @end_month }

      return "Lottery Data not Found" if record.nil?

      record.each{|k, v| instance_variable_set("@#{k}", v) }

      return "錯誤" if @so_special_price.nil? || @special_price.nil? || @head_prices.nil? || @additional_sixth_prices.nil?
      return "特別獎" if invoice_code == @so_special_price
      return "特獎" if invoice_code == @special_price

      @head_prices.each{|head| return "頭獎" if invoice_code == head }
      @head_prices.each{|head| return "二獎" if invoice_code[1..-1] == head[1..-1] }
      @head_prices.each{|head| return "三獎" if invoice_code[2..-1] == head[2..-1] }
      @head_prices.each{|head| return "四獎" if invoice_code[3..-1] == head[3..-1] }
      @head_prices.each{|head| return "五獎" if invoice_code[4..-1] == head[4..-1] }
      @head_prices.each{|head| return "六獎" if invoice_code[5..-1] == head[5..-1] }

      @additional_sixth_prices.each{|six| return "增開六獎" if invoice_code[-3..-1] == six}

      return "下次再來，兩個月後又是一條好漢"
    end
  end
end
end
