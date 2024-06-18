# プレイヤーをデータベースに保存するseedファイル

# 現在は23-24シーズンにPLに在籍したプレイヤーのみのコード

# t.string "name"
# t.string "position"
# t.integer "shirt_number", limit: 2
# t.bigint "team_id"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["team_id"], name: "index_players_on_team_id"


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

required_information = []

array_response.each{|data|
  team = Team.find_by(tla: data["tla"])
  squad = data["squad"]

  squad.each{|player|
    selected_data = {
      team: team,
      name: player["name"],
      position: player["position"],
      shirt_number: player["shirtNumber"]
    }

    required_information.push(selected_data)
  }
}


p required_information

required_information.each{ |player|
  team = player[:team]
  team.players.create!(
    name: player[:name],
    position: player[:position],
    shirt_number: player[:shirt_number]
  )
}
