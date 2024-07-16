class EmailController < ApplicationController

  def send_email
    if current_user
      UserMailer.test(current_user).deliver_now
      render json: { message: 'Email sent successfully' }, status: :ok
    else
      render json: { error: 'User not authenticated' }, status: :unauthorized
    end
  end
end
