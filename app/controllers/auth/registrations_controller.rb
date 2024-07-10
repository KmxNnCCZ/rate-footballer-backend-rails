# 認証を行うコントローラー

class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  def sign_up_params
    params.permit(:name, :email, :password)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end