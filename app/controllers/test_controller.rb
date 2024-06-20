class TestController < ApplicationController
  def index
    p "TestController"
    p params
    base_url = "http://api.football-data.org/v4"
    header = { 'X-Auth-Token' => ENV['FOOTBALL_DATA_API_TOKEN']}
    
    if params[:path].present?
      concatenated_uri = base_url + "/" + params[:path]
    else
      concatenated_uri = base_url
    end

    url = URI.parse(concatenated_uri)
    https = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    request['X-Auth-Token'] = header['X-Auth-Token']

    response = https.request(request)
    render json: response.read_body
  end
end
