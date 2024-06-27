require Rails.root.join('app', 'lib', 'api', 'access_log')

class CompetitionMatchesController < ApplicationController
  def index
    matches = Match.all

    if params[:season].present?
      matches = matches.where(season: params[:season])
    end

    if params[:matchday].present?
      matches = matches.where(matchday: params[:matchday])
    end

    matches = matches.includes(:home_team, :away_team)

    matches_with_team_data = matches.map do |match|
      {
        match: {
          match_api_id: match.match_api_id,
          utcDate: match.utcDate,
          home_team_score: match.home_team_score,
          away_team_score: match.away_team_score,
          matchday: match.matchday
        },
        home_team_data: {
          tla: match.home_team.tla,
          venue: match.home_team.venue,
          crest_url: match.home_team.crest_url,

        },
        away_team_data: {
          tla: match.away_team.tla,
          crest_url: match.away_team.crest_url,
        }
      }
    end
    render json: matches_with_team_data
  end

  def show
    res = Api::AccessLog.get("matches/#{params[:id]}")

    if params[:team]
      parsed_res = JSON.parse(res) # レスポンスをJSON形式に変換
      team_data = parsed_res["#{params[:team]}Team"]
      team_data[:matchday] = parsed_res["matchday"]
      reverse_team = params[:team] == "home" ? "away" : "home"
      team_data[:awayTeamName] = parsed_res["#{reverse_team}Team"]["name"]
      team_data[:awayTeamCrest] = parsed_res["#{reverse_team}Team"]["crest"]
      team_data[:score] = "#{parsed_res["score"]["fullTime"][params["team"]]}-#{parsed_res["score"]["fullTime"][reverse_team]}"
      render json: team_data
    else
      render json: res
    end
  end
end
