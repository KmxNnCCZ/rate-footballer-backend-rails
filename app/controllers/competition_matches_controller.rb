require Rails.root.join('app', 'lib', 'api', 'access_log')

class CompetitionMatchesController < ApplicationController
  def index
    p "comming CompetitionMatchesController"
    p params

    matches = Match.all

    if params[:season].present?
      matches = matches.where(season: params[:season])
    end

    if params[:matchday].present?
      matches = matches.where(matchday: params[:matchday])
    end

    render json: matches
  end

  def show
    p params[:id]
    res = Api::AccessLog.get("matches/#{params[:id]}")
    p res
    render json: res
  end
end
