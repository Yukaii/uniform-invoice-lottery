module UniformInvoiceLottery
  class Prize
    def title
      self.class.const_get(:TITLE)
    end

    def amount
      self.class.const_get(:AMOUNT)
    end

    def priority
      self.class.const_get(:PRIORITY)
    end
  end

  class SpecialPrize < Prize
    TITLE = "特別獎"
    AMOUNT = 10_000_000
    PRIORITY = 1
  end

  class GrandPrize < Prize
    TITLE = "特獎"
    AMOUNT = 2_000_000
    PRIORITY = 2
  end

  class FirstPrize < Prize
    TITLE = "頭獎"
    AMOUNT = 200_000
    PRIORITY = 3
  end

  class SecondPrize < Prize
    TITLE = "二獎"
    AMOUNT = 40_000
    PRIORITY = 4
  end

  class ThirdPrize < Prize
    TITLE = "三獎"
    AMOUNT = 10_000
    PRIORITY = 5
  end

  class FourthPrize < Prize
    TITLE = "四獎"
    AMOUNT = 4000
    PRIORITY = 6
  end

  class FifthPrize < Prize
    TITLE = "五獎"
    AMOUNT = 1000
    PRIORITY = 7
  end

  class SixthPrize < Prize
    TITLE = "六獎"
    AMOUNT = 200
    PRIORITY = 8
  end

  class AdditionalSixthPrize < Prize
    TITLE = "增開六獎"
    AMOUNT = 200
    PRIORITY = 9
  end

  class NullPrize < Prize
    TITLE = "沒中"
    AMOUNT = 0
    PRIORITY = 999
  end
end
