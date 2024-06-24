# 実際にapiとデータのやり取りをするクラス

module Api
  class AccessLogApi
    BASE_URL = "http://api.football-data.org/v4"
    HEADER = { 'X-Auth-Token' => ENV['FOOTBALL_DATA_API_TOKEN']}
  
    def self.get(path)
      concatenated_uri = "#{BASE_URL}/#{path}"

      url = URI.parse(concatenated_uri)
      https = Net::HTTP.new(url.host, url.port)

      request = Net::HTTP::Get.new(url)
      request['X-Auth-Token'] = HEADER['X-Auth-Token']

      response = https.request(request)
      return response.read_body
    end

  end
end