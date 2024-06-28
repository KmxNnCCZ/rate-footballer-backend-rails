# 試合一覧をデータベースに保存するseedファイル

# t.integer "match_api_id", null: false
# t.date "utcDate", null: false
# t.string "season", limit: 5, null: false
# t.integer "home_team_score", null: false
# t.integer "away_team_score", null: false
# t.bigint "home_team_id"
# t.bigint "away_team_id"
# t.integer "matchday"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["away_team_id"], name: "index_matches_on_away_team_id"
# t.index ["home_team_id"], name: "index_matches_on_home_team_id"

base_url = "http://api.football-data.org/v4/competitions/PL/matches"
header = { 'X-Auth-Token' => ENV['FOOTBALL_DATA_API_TOKEN']}


(1..38).each{|matchday|
  full_url = "#{base_url}?matchday=#{matchday}&season=#{2023}"
  p full_url

  url = URI.parse(full_url)
  https = Net::HTTP.new(url.host, url.port)

  request = Net::HTTP::Get.new(url)
  request['X-Auth-Token'] = header['X-Auth-Token']

  response_body = https.request(request).read_body

  # Parse the JSON response body into a Ruby hash
  parsed_response = JSON.parse(response_body)

  array_response = parsed_response['matches']

  # 得られた情報から必要な情報だけを抽出し保存
  array_response.each do |data|
    home_team = Team.find_by(tla: data["homeTeam"]["tla"])
    away_team = Team.find_by(tla: data["awayTeam"]["tla"])
    season = data["season"]["startDate"].slice(2, 2) + "-" + data["season"]["endDate"].slice(2, 2)
  
    if Match.find_by(match_api_id: data["id"]).nil?
      Match.create!(
        match_api_id: data["id"],
        utcDate: data["utcDate"],
        season: season,
        home_team_score: data["score"]["fullTime"]["home"],
        away_team_score: data["score"]["fullTime"]["away"],
        matchday:  data["matchday"],
        home_team_id: home_team.id,
        away_team_id: away_team.id
      )
    end
  end

  # 一気に取得するとAPIの制限がかかるので各節ごとに3秒まつ
  sleep(3)
}