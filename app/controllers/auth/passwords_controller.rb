# パスワード更新用コントローラー

class Auth::PasswordsController < DeviseTokenAuth::ApplicationController

  def create
    # メールアドレスからユーザーを探し、パスワードリセットのメールを送信する
    user = User.find_by(email: params[:email])
    if user.present?
      reset_password_token = Devise.friendly_token
      # ユーザーにリセットトークンと送信時間を保存
      user.update_columns(
        reset_password_token: reset_password_token,
        reset_password_sent_at: Time.now.utc
      )
      UserMailer.change_request_email(user, ENV['FRONT_DOMAIN']).deliver_now
      # メール送信が完了した旨をレスポンスとして返す
      render json: { message: 'Reset password email sent successfully.', status: 'success' }, status: :ok
    else
      # 該当のメールアドレスのユーザーがいなかった場合は、その旨をレスポンスとして返す
      render json: { error: 'There is no registered user linked with this email.', status: 'error' }, status: :not_found
    end
  end

  # edit アクションは、reset_password_token が有効かチェックし、パスワード変更フォームを表示する処理を追加することができます
  def edit
    @user = User.find_by(reset_password_token: params[:token])
    if @user
      if @user.reset_password_token_valid?
        @user.allow_password_change = true # パスワード変更フォームを有効化
        @user.save
        # トークンが有効な場合、200 OK を返す
        render json: { message: "トークンは有効です" }, status: :ok
      else
        # トークンが期限切れの場合、400 Bad Request を返す
        render json: { message: "トークンの有効期限が切れました。再度リクエストしてください。" }, status: :bad_request
      end
    else
      # ユーザーが存在しない場合、404 Not Found を返す
      render json: { message: "トークンが無効です。" }, status: :not_found
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:token])

    if @user.nil?
      render json: { error: "トークンが無効です。", status: :not_found }
      return
    end

    if @user.reset_password_period_valid?
      if @user.update(password: params[:password])
        # パスワードの更新に成功した場合、リセットトークンを削除する
        @user.clear_reset_password_token
        @user.allow_password_change = false
        @user.save
        render json: { message: "パスワードが正常に更新されました。", status: :ok }
      else
        render json: { error: @user.errors.full_messages.join(", "), status: :unprocessable_entity }
      end
    else
      render json: { error: "トークンの有効期限が切れました。再度リクエストしてください。", status: :bad_request }
    end
  end
end