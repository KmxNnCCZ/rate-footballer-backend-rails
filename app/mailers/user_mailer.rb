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
end
