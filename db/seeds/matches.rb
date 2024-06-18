# 試合一覧をデータベースに保存するseedファイル

# t.integer "match_api_id", null: false
# t.date "utcDate", null: false
# t.string "season", limit: 5, null: false
# t.integer "home_team_score", null: false
# t.integer "away_team_score", null: false
# t.bigint "home_team_id"
# t.bigint "away_team_id"
# t.integer "match_day"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["away_team_id"], name: "index_matches_on_away_team_id"
# t.index ["home_team_id"], name: "index_matches_on_home_team_id"

base_url = "http://api.football-data.org/v4/competitions/PL/matches"
header = { 'X-Auth-Token' => ENV['FOOTBALL_DATA_API_TOKEN']}

required_information = []

38.times{|matchday|
  full_url = base_url + "?matchday=#{matchday + 1}"
  # p full_url

  url = URI.parse(full_url)
  https = Net::HTTP.new(url.host, url.port)

  request = Net::HTTP::Get.new(url)
  request['X-Auth-Token'] = header['X-Auth-Token']

  response_body = https.request(request).read_body

  # Parse the JSON response body into a Ruby hash
  parsed_response = JSON.parse(response_body)

  array_response = parsed_response['matches']

  # 得られた情報から必要な情報だけを抽出
  array_response.each{|data|

    home_team = Team.find_by(tla: data["homeTeam"]["tla"])
    away_team = Team.find_by(tla: data["awayTeam"]["tla"])
    season = data["season"]["startDate"].slice(2, 2) + "-" + data["season"]["endDate"].slice(2, 2)

    selected_data = {
      match_api_id: data["id"],
      utcDate: data["utcDate"],
      season: season,
      home_team_score: data["score"]["fullTime"]["home"],
      away_team_score: data["score"]["fullTime"]["away"],
      home_team: home_team,
      away_team: away_team,
      match_day: data["matchday"]
    }

    required_information.push(selected_data)
  }
}

p required_information

required_information.each{|match|
  home_team = match[:home_team]
  away_team = match[:away_team]

  Match.create!(
    match_api_id: match[:match_api_id],
    utcDate: match[:utcDate],
    season: match[:season],
    home_team_score: match[:home_team_score],
    away_team_score: match[:away_team_score],
    match_day: match[:match_day],
    home_team_id: home_team.id,
    away_team_id: away_team.id
  )
}