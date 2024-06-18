# チームをデータベースに保存するseedファイル

# 現在は23-24シーズンにPLに在籍したチームのみのコード

# create_table "teams", force: :cascade do |t|
#   t.string "name", null: false
#   t.string "short_name", null: false
#   t.string "tla", limit: 3, null: false
#   t.integer "team_api_id", null: false
#   t.string "venue", null: false
#   t.string "crest_url", null: false
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end


base_url = "http://api.football-data.org/v4/competitions/PL/teams"
header = { 'X-Auth-Token' => ENV['FOOTBALL_DATA_API_TOKEN']}

url = URI.parse(base_url)
https = Net::HTTP.new(url.host, url.port)

request = Net::HTTP::Get.new(url)
request['X-Auth-Token'] = header['X-Auth-Token']

response_body = https.request(request).read_body

# RubyのhashにJsonデータをパース
parsed_response = JSON.parse(response_body)

array_response = parsed_response['teams']

# 得られた情報から必要な情報だけを抽出
required_information = []
array_response.each{|data|
  selected_data = {
    name: data["name"],
    short_name: data["shortName"],
    tla: data["tla"],
    team_api_id: data["id"],
    venue: data["venue"],
    crest_url: data["crest"]
  }
  required_information.push(selected_data)
}

# p required_information

required_information.each{ |team|
  p team
  Team.create!(
    name: team[:name],
    short_name: team[:short_name],
    tla: team[:tla],
    team_api_id: team[:team_api_id],
    venue: team[:venue],
    crest_url: team[:crest_url]
  )
}
