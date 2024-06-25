require Rails.root.join('app', 'lib', 'api', 'access_log')

class CompetitionMatchesController < ApplicationController
  def index
    p "comming CompetitionMatchesController"

    matches = Match.all

    if params[:season].present?
      matches = matches.where(season: params[:season])
    end

    if params[:matchday].present?
      matches = matches.where(matchday: params[:matchday])
    end

    matches_with_team_data = matches.map do |match|
      {
        match: match,
        home_team_data: Team.find(match.home_team_id),
        away_team_data: Team.find(match.away_team_id)
      }
    end
  
    render json: matches_with_team_data
  end

  def show
    p params[:id]
    res = Api::AccessLog.get("matches/#{params[:id]}")
    p res
    render json: res
  end
end
