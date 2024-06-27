class RatesController < ApplicationController
  def create
    match = Match.find_by(match_api_id: params[:match_api_id])

    ActiveRecord::Base.transaction do
      created_rate = match.rates.create(
        is_home_team: params[:team] == "home",
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
          p score_params
            created_rate.scores.create(score_params)
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