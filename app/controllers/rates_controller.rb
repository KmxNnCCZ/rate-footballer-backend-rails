require Rails.root.join('app', 'modules', 'player_sorter')

class RatesController < ApplicationController

  # /rates
  def index
    rates = Rate.includes(:match, :team, :user, scores: :player).all
    rate_with_scores = rates.map do |rate|

      sorted_scores = PlayerSorter.sort_players(rate.scores.map do |score|
        {
          player_id: score.player_id,
          position: score.player.position,
          shirt_number: score.player.shirt_number,
          name: score.player.name,
          score: score.score,
          assessment: score.assessment,
        }
      end)
      {
        id: rate.id,
        matchday: rate.match.matchday,
        season: rate.match.season,
        user_id: rate.user_id,
        user_name: rate.user.name,
        team_short_name: rate.team.short_name,
        team_crest_url: rate.team.crest_url,
        scores: sorted_scores,
        updated_at: rate.updated_at
      }
    end
    render json: rate_with_scores
  end

  # /rates/:rateId
  def show
    rate = Rate.includes(:match, :team, :user, scores: :player).find(params[:id])
    sorted_scores = PlayerSorter.sort_players(rate.scores.map do |score|
      {
        player_id: score.player_id,
        position: score.player.position,
        shirt_number: score.player.shirt_number,
        name: score.player.name,
        score: score.score,
        assessment: score.assessment,
      }
    end)
    rate_with_scores = {
      id: rate.id,
      matchday: rate.match.matchday,
      match_api_id: rate.match.match_api_id,
      season: rate.match.season,
      user_id: rate.user_id,
      user_name: rate.user.name,
      team_name: rate.team.name,
      team_crest_url: rate.team.crest_url,
      scores: sorted_scores,
      comments: rate.comments.includes(:user).map do |comment|
        {
          id: comment.id,
          user_id: comment.user_id,
          user_name: comment.user.name,
          body: comment.body,
          updated_at: comment.updated_at
        }
      end
    }
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

  # /rates/:rateId/edit
  def edit
    rate = Rate.includes(:match, :team, :user, scores: :player).find(params[:id])
    is_home = rate.match.home_team_id == rate.team_id
    match = rate.match
    reverse_team = is_home ? match.away_team : match.home_team

    sorted_scores = PlayerSorter.sort_players((rate.scores).map do |score|
      {
        player_id: score.player.id,
        position: score.player.position,
        shirt_number: score.player.shirt_number,
        name: score.player.name,
        score: score.score,
        assessment: score.assessment,
      }
    end)
    rate_with_scores = {
      id: rate.id,
      matchday: rate.match.matchday,
      match_api_id: rate.match.match_api_id,
      season: rate.match.season,
      user_id: rate.user_id,
      team_id: rate.team_id,
      user_name: rate.user.name,
      team_name: rate.team.name,
      team_crest_url: rate.team.crest_url,
      reverse_team_name: reverse_team.name,
      reverse_team_crest_url: reverse_team.crest_url,
      match_score: is_home ? "#{rate.match.home_team_score}-#{rate.match.away_team_score}" : "#{rate.match.away_team_score}-#{rate.match.home_team_score}",
      scores: sorted_scores
    }
    render json: rate_with_scores
  end

  def update
    params[:player_rates].each do |player_rate|
      score = Score.find_by(rate_id: params[:id], player_id: player_rate[:player_id])
      next Rails.logger.error "Score not found for player_id #{player_rate[:player_id]}" unless score
  
      score_params = { score: player_rate[:score] }
      score_params[:assessment] = player_rate[:assessment] if player_rate[:assessment].present?
  
      score.update(score_params)
    end
  end

  def destroy
    rate = Rate.find(params[:id]);
    rate.destroy
  end


  private

  def rate_params
    params.require(:params).permit(:match_api_id, :team, player_rates: [:player_api_id, :score, :assessment])
  end
end