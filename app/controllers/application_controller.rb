class ApplicationController < ActionController::Base
  # user_signed_in?メソッドを使うためにSetUserByTokenをinclude
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  # token検証をスキップ
  skip_before_action :verify_authenticity_token


  def hello_world
    render json: { text: "Hello World" }
  end
end