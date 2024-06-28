class RatesController < ApplicationController

  def index
    rates = Rate.includes(:match, :team, scores: :player).all
    rate_with_scores = rates.map do |rate|
      {
        id: rate.id,
        matchday: rate.match.matchday,
        season: rate.match.season,
        user_id: rate.user_id,
        team_short_name: rate.team.short_name,
        team_crest_url: rate.team.crest_url,
        scores: rate.scores.map do |score|
          {
            player_id: score.player_id,
            score: score.score,
            name: score.player.name,
            position: score.player.position,
            shirt_number: score.player.shirt_number
          }
        end
      }
    end
    render json: rate_with_scores
  end

  def create
    match = Match.find_by(match_api_id: params[:match_api_id])
    team = params[:team] == "home" ? match.home_team : match.away_team

    ActiveRecord::Base.transaction do
      new_rate = match.rates.create(
        team_id: team.id,
        user_id: current_user.id
      )

      params[:player_rates].each do |player_rate|
        player = Player.find_by(player_api_id: player_rate[:player_api_id])
        if player
          score_params = {
            player_id: player.id,
            score: player_rate[:score]
          }

          # assessment が存在する場合の処理
          if player_rate[:assessment].present?
            score_params[:assessment] = player_rate[:assessment]
          end
          new_rate.scores.create(score_params)
        else # プレイヤーが見つからなかった場合の処理
          Rails.logger.error "Player with player_api_id=#{player_rate[:player_api_id]} not found"
        end
      end
    end
  end


  private

  def rate_params
    params.require(:params).permit(:match_api_id, :team, player_rates: [:player_api_id, :score, :assessment])
  end
end