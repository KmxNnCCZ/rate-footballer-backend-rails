class ApplicationController < ActionController::Base
  # user_signed_in?メソッドを使うためにSetUserByTokenをinclude
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  # token検証をスキップ
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?


  def hello_world
    render json: { text: "Hello World" }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email])
  end
end