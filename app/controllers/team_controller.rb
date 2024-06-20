class TeamController < ApplicationController
  def index
    team = Team.find(params[:id])
    render json: team
  end
end
