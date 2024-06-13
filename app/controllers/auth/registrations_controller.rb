# 認証を行うコントローラー

class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  wrap_parameters false

  def sign_up_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end