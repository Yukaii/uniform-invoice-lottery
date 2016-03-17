module UniformInvoiceLottery
  module Support

    # 計算開獎月份
    def get_draw_month time=Time.now
      if time.month % 2 == 1
        if time.day >= 25 # 奇數月開獎後那幾天
          return time.month
        else
          return time.month-2 < 0 ? (time.month-2 + 12) : time.month-2
        end
      else # 偶數月，一律是在前一個月
        return time.month-1
      end
    end

    # 回傳開獎月份數組
    def get_lottery_months draw_month=get_draw_month
      # draw_month = get_draw_month(draw_month) if draw_month % 2 == 0
      raise InvalidLotteryMonthError, "奇數月開獎" if draw_month % 2 == 0
      return (draw_month-2 + 12)%12, (draw_month-2 + 12)%12 + 1
    end

    def get_lottery_date draw_month=get_draw_month, year=Time.now.year
      raise InvalidLotteryMonthError, "奇數月開獎" if draw_month % 2 == 0
      start_month, end_month = (draw_month-2 + 12)%12, (draw_month-2 + 12)%12 + 1
      year -= 1 if [start_month, end_month] == [11, 12] # 前一年的開獎
      return start_month, end_month, year-1911
    end

  end
end
