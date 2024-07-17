class RankingController < ApplicationController
  def index
    # Playerごとにscoreの平均値を計算
    ranking = Score.joins(player: :team)
      .select("players.id as player_id, 
        players.player_api_id, 
        players.name, 
        players.position, 
        players.shirt_number, 
        teams.name as team_name, 
        teams.short_name,
        teams.crest_url as crest_url,
        AVG(scores.score) as average_score"
      ).group("players.id, 
        players.player_api_id, 
        players.name, 
        players.position, 
        players.shirt_number, 
        teams.short_name,
        teams.name,
        crest_url
        "
      ).order("average_score DESC")

     # 結果を整形
    formatted_ranking = ranking.map do |rank|
      {
        player_id: rank.player_id,
        player_api_id: rank.player_api_id,
        name: rank.name,
        position: rank.position,
        shirt_number: rank.shirt_number,
        team: rank.team_name,
        short_name: rank.short_name,
        crest_url: rank.crest_url,
        average_score: rank.average_score.to_f
      }
    end

    render json: formatted_ranking
  end
end
