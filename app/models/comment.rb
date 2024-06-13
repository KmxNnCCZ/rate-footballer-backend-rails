=begin
  t.bigint "rate_id", null: false
  t.bigint "user_id", null: false
  t.text "body", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["rate_id"], name: "index_comments_on_rate_id"
  t.index ["user_id"], name: "index_comments_on_user_id"
=end

class Comment < ApplicationRecord
  belongs_to :rate
  belongs_to :user

  valudates :body, presence: true
end
