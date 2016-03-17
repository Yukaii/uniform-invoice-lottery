require 'nokogiri'
require 'httpclient'
require 'json'
require 'yaml'

module UniformInvoiceLottery
  class LotteryCrawler
    include Support
    attr_accessor :records, :last_updated_at

    class << self
      def update_lottery
        if !crawler.record_loaded?
          crawler.load_record
        end

        if !crawler.latest?
          crawler.fetch_lottery
          crawler.save_record
        end
      end

      def crawler
        @@instance ||= self.new
      end

      def find_record_by year: nil, start_month: nil, end_month: nil
        if !(year && start_month && end_month)
          raise InvalidArgumentsError
        end

        return crawler.records.find{|rec| rec["year"] == year && rec["start_month"] == start_month && rec["end_month"] == end_month }
      end
    end

    # instance methods
    def fetch_lottery
      # if no record found
      @doc = Nokogiri::HTML(http_client.get_content "http://www.etax.nat.gov.tw/etwmain/front/ETW183W1")
      # lottery_lists = [
      #   ["ETW183W2?id=14c4f826ecb00000aae8b5c3346d4493", "104年01月、02月"],
      #   ["ETW183W2?id=14b1f79bc5700000a9ef78b1708be70d", "103年11月、12月"],
      #   ["ETW183W2?id=149e58cdb5a00000d2d54a98932994cb", "103年09月、10月"],
      #   ...
      # ]
      lottery_lists = @doc.css('table#fbonly a').map{|node| [node[:href], node.text]}.select{|arr| !!arr[1].match(/(?<year>\d+)年(?<m1>\d+)月、(?<m2>\d+)月/)}

      threads = []
      @records = []

      lottery_lists.each do |lot|
        threads << Thread.new do
          doc = Nokogiri::HTML(http_client.get_content("http://www.etax.nat.gov.tw/#{lot[0]}").to_s.force_encoding('utf-8'))
          rows = doc.css('table tr')

          m = doc.css('h4').text.match(/(?<year>\d+)年(?<m1>\d+)月、(?<m2>\d+)月/)
          year = m[:year].to_i
          start_month = m[:m1].to_i
          end_month = m[:m2].to_i

          prizes = doc.css('span.t18Red').map(&:text)

          special_prize = prizes[0]
          grand_prize = prizes[1]
          first_prizes = prizes[2].split('、')
          additional_sixth_prizes = prizes[3].split('、')

          @records << {
            "year"                    => year,
            "start_month"             => start_month,
            "end_month"               => end_month,
            "special_prize"           => special_prize,
            "grand_prize"             => grand_prize,
            "first_prizes"            => first_prizes,
            "additional_sixth_prizes" => additional_sixth_prizes,
          }
        end # Thread.new do
      end # lottery_lists.each

      threads.map(&:join)

      sort_record!
      @records
    end # crawl_lottery_data

    def load_record dir=ROOT_DIR
      filepath = File.join(dir, 'record.yaml')
      return false if !File.exists?(filepath)

      data = YAML.load(File.read(File.join(dir, 'record.yaml')))

      @last_updated_at = Time.parse data["last_updated_at"]
      @records = data["records"]

      true
    end

    def save_record dir=ROOT_DIR
      data = {
        "last_updated_at" => Time.now.to_s,
        "records" => @records
      }
      File.write(File.join(dir, 'record.yaml'), data.to_yaml)
    end

    def latest?
      start_month, end_month, year = get_lottery_date

      # 最近年分不是空的就是最新
      return (
        @last_updated_at && @records && !@records.empty? && !@records.find{ |rec|
          rec["year"] == year && rec["start_month"] == start_month && rec["end_month"] == end_month
        }.nil?)
    end

    def record_loaded?
      !@records.nil?
    end

    private

      def http_client
        @client ||= HTTPClient.new
      end

      def td_xpath(th)
        return "\/\/th\[.=\"#{th}\"\]\/ancestor::tr\/td"
      end

      def sort_record!
        @records = @records.sort_by{ |rec| "#{rec["year"]}#{rec["end_month"].to_s.rjust(2, "0")}".to_i }.reverse!
      end
  end
end
