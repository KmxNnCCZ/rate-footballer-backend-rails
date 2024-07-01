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

(2021..2023).each do |season|

  full_url = "#{base_url}?season=#{season}"

  url = URI.parse(full_url)
  https = Net::HTTP.new(url.host, url.port)

  request = Net::HTTP::Get.new(url)
  request['X-Auth-Token'] = header['X-Auth-Token']

  response_body = https.request(request).read_body

  # RubyのhashにJsonデータをパース
  parsed_response = JSON.parse(response_body)

  array_response = parsed_response['teams']

  # 得られた情報から必要な情報だけを抽出して保存
  array_response.each{|data|
    if Team.find_by(tla: data["tla"]).nil?
      Team.create!(
        name: data["name"],
        short_name: data["shortName"],
        tla:  data["tla"],
        team_api_id: data["id"],
        venue: data["venue"],
        crest_url: data["crest"]
      )
    end
  }

end