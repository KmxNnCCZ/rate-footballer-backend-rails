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
        match: match,
        home_team_data: match.home_team,
        away_team_data: match.away_team
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
