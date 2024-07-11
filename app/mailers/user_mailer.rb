class UserMailer < ApplicationMailer
  default from: 'from@example.com'

  def test(user)
    # p "mailer"
    p user
    @user = user
    p @user.name
    @url = 'https://google.com'
    mail(to: @user.email, subject: 'これはテストです')
  end

  # パスワード変更の際に送るメール
  def change_request_email(user, base_url)
    @user = user
    p base_url
    @url = "#{base_url}/user/edit/#{@user.reset_password_token}"
    mail(to: @user.email, subject: 'パスワード変更リクエスト')
  end
end
