require 'nokogiri'
require 'httpclient'
require 'json'

module UniformInvoiceLottery
  module DataCrawler

    class Crawler

      def load_lottery
        # not record found
        @doc = Nokogiri::HTML(client.get_content "http://www.etax.nat.gov.tw/etwmain/front/ETW183W1")
        # lottery_lists = [
        #   ["ETW183W2?id=14c4f826ecb00000aae8b5c3346d4493", "104年01月、02月"],
        #   ["ETW183W2?id=14b1f79bc5700000a9ef78b1708be70d", "103年11月、12月"],
        #   ["ETW183W2?id=149e58cdb5a00000d2d54a98932994cb", "103年09月、10月"],
        #   ...
        # ]
        lottery_lists = @doc.css('#searchForm a').map{|node| [node[:href], node.text]}.select{|arr| !!arr[1].match(/(?<year>\d+)年(?<m1>\d+)月、(?<m2>\d+)月/)}

        threads = []

        lottery_lists.each do |lot|
          threads << Thread.new do
            doc = Nokogiri::HTML(client.get_content("http://www.etax.nat.gov.tw/etwmain/front/#{lot[0]}").to_s.force_encoding('utf-8'))
            rows = doc.css('table.table_b tr')

            m = doc.css('h4').text.match(/(?<year>\d+)年(?<m1>\d+)月、(?<m2>\d+)月/)
            year = m[:year].to_i
            start_month = m[:m1].to_i
            end_month = m[:m2].to_i
            so_special_price = rows.xpath(td_xpath "特別獎" ).text.strip
            special_price = rows.xpath(td_xpath "特獎" ).text.strip
            head_prices = rows.xpath(td_xpath "頭獎" ).text.strip.split('、')
            additional_sixth_prices = rows.xpath(td_xpath "增開六獎" ).text.strip.split('、')

            records << {
              "year" => year,
              "start_month" => start_month,
              "end_month" => end_month,
              "so_special_price" => so_special_price,
              "special_price" => special_price,
              "head_prices" => head_prices,
              "additional_sixth_prices" => additional_sixth_prices,
            }
          end # Thread.new do
        end # lottery_lists.each

        threads.map(&:join)

        sort_record!
        records
      end # load_lottery

      def sort_record!
        records = @records.sort_by{ |rec| "#{@year}#{@end_month}".to_i }
      end

      def td_xpath(th)
        return "\/\/th\[.=\"#{th}\"\]\/ancestor::tr\/td"
      end

      def records
        @records ||= []
      end

      private
        def client
          @client ||= HTTPClient.new
        end
    end

    class << self

      def load
        # TODO: check if local file exist
        crawler.load_lottery
      end

      def records
        crawler.records
      end

      private

      def crawler
        @@crawler ||= Crawler.new
      end

      def get_draw_month time=Time.now
        if time.month % 2 == 1
          if time.day >= 25 # 奇數月開獎後那幾天
            return time.month
          else
            return time.month-2 < 0 ? (time.month-2 + 12) : time.month-2
          end
        else # 偶數月
          return time.month-1
        end
      end

      def get_lottery_months draw_month=get_draw_month
        draw_month = get_draw_month(draw_month) if draw_month % 2 == 0
        return (draw_month-2 + 12)%12, (draw_month-2 + 12)%12 + 1
      end

    end
  end
end
