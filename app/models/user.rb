=begin
  t.string "name", default: "", null: false
  t.string "email", default: "", null: false
  t.string "encrypted_password", default: "", null: false
  t.string "reset_password_token"
  t.datetime "reset_password_sent_at"
  t.datetime "remember_created_at"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.string "provider", default: "email", null: false
  t.string "uid", default: "", null: false
  t.boolean "allow_password_change", default: false
  t.string "confirmation_token"
  t.datetime "confirmed_at"
  t.datetime "confirmation_sent_at"
  t.string "unconfirmed_email"
  t.json "tokens"
  t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  t.index ["email"], name: "index_users_on_email", unique: true
  t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
=end


class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :rates
  has_many :comments

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, uniqueness: true

  # パスワード変更用
  def reset_password_token_valid?
    reset_password_sent_at > 30.minutes.ago
  end

  def clear_reset_password_token
    self.reset_password_token = nil
    self.reset_password_sent_at = nil
  end

end
