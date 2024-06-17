require Rails.root.join('app', 'lib', 'api', 'access_log')

class CompetitionMatchesController < ApplicationController
  def index
    p "comming CompetitionMatchesController"
    p params[:filter]
    p params[:filter]
    p params[:filter]
    p params[:filter]
    p params[:filter]
    p params[:filter]
    response = Api::AccessLog.all("competitions", "PL", "matches")
    # response = Api::AccessLog.all("competitions/PL/matches?matchday=38")
    p "CompetitionMatchesController response"
    # p response
    render json: response
  end
end
