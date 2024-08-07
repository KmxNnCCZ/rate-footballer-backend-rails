class UserMailer < ApplicationMailer
  default from: 'from@example.com'

  def test(user)
    @user = user
    @url = 'https://google.com'
    mail(to: @user.email, subject: 'これはテストです')
  end

  # パスワード変更の際に送るメール
  def change_request_email(user)
    @user = user
    @url = "#{ENV['FRONT_DOMAIN']}/user/edit/#{@user.reset_password_token}"
    mail(to: @user.email, subject: 'パスワード変更リクエスト')
  end
end
