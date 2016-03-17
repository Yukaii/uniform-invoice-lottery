module UniformInvoiceLottery
  class LotteryCheckService
    include Support

    def check invoice_code, opts={}

      LotteryCrawler.update_lottery

      record = load_record(opts)

      return NullPrize.new if record.nil? # might raise an error

      record.each{|k, v| instance_variable_set("@#{k}", v) }

      return NullPrize.new if @special_prize.nil? || @grand_prize.nil? || @first_prizes.nil? || @additional_sixth_prizes.nil?
      return SpecialPrize.new if invoice_code == @special_prize
      return GrandPrize.new if invoice_code == @grand_prize

      @first_prizes.each{|head| return FirstPrize.new if invoice_code == head }
      @first_prizes.each{|head| return SecondPrize.new if invoice_code[1..-1] == head[1..-1] }
      @first_prizes.each{|head| return ThirdPrize.new if invoice_code[2..-1] == head[2..-1] }
      @first_prizes.each{|head| return FourthPrize.new if invoice_code[3..-1] == head[3..-1] }
      @first_prizes.each{|head| return FifthPrize.new if invoice_code[4..-1] == head[4..-1] }
      @first_prizes.each{|head| return SixthPrize.new if invoice_code[5..-1] == head[5..-1] }

      @additional_sixth_prizes.each{|six| return AdditionalSixthPrize.new if invoice_code[-3..-1] == six}

      return NullPrize.new
    end

    private

      def load_record opts
        if opts.is_a? Hash
          options = %i(time year month day)
          opts = Hash[opts.map{|k, v| [k.to_sym, v]}]

          # white list filtering
          opts = Hash[options.zip(opts.values_at(*options))]
        end

        @time = (
            opts[:year] &&
            opts[:month] &&
            opts[:day] &&
            Time.new(opts[:year], opts[:month], opts[:day])
          ) || opts[:time] ||Time.now
        start_month, end_month, year = get_lottery_date(get_draw_month(@time), @time.year)

        record = LotteryCrawler.find_record_by(
          year: year,
          start_month: start_month,
          end_month: end_month
        )
      end
  end
end
