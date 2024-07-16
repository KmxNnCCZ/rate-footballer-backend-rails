require Rails.root.join('app', 'lib', 'api', 'access_log')
require Rails.root.join('app', 'modules', 'player_sorter')
require 'active_support/core_ext/hash/keys'

class CompetitionMatchesController < ApplicationController

  # /matches
  def index
    matches = Match.includes(:home_team, :away_team)

    matches = matches.season(params[:season]) if params[:season].present?
    matches = matches.matchday(params[:matchday]) if params[:matchday].present?

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

  # /matches/:matchApiId
  # /matches/:matchApiId/rate?team=
  def show
    res = Api::AccessLog.get("matches/#{params[:id]}")
    parsed_res = JSON.parse(res).deep_symbolize_keys # レスポンスをJSON形式に変換

    if params[:team]
      team_data = parsed_res[:"#{params[:team]}Team"]
      team_data[:lineup] = PlayerSorter.sort_players(team_data[:lineup])
      team_data[:matchday] = parsed_res[:matchday]
      reverse_team = params[:team] == "home" ? "away" : "home"
      team_data[:awayTeamName] = parsed_res[:"#{reverse_team}Team"][:name]
      team_data[:awayTeamCrest] = parsed_res[:"#{reverse_team}Team"][:crest]
      team_data[:score] = "#{parsed_res[:score][:fullTime][:"#{params["team"]}"]}-#{parsed_res[:score][:fullTime][:"#{reverse_team}"]}"
      render json: team_data
    else

      parsed_res[:homeTeam][:lineup] = PlayerSorter.sort_players(parsed_res[:homeTeam][:lineup])
      parsed_res[:awayTeam][:lineup] = PlayerSorter.sort_players(parsed_res[:awayTeam][:lineup])
      render json: parsed_res
    end
  end
end
