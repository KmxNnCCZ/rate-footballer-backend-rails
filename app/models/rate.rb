=begin
  t.boolean "is_home_team", null: false
  t.bigint "match_id", null: false
  t.bigint "user_id", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["match_id"], name: "index_rates_on_match_id"
  t.index ["user_id"], name: "index_rates_on_user_id"
=end

class Rate < ApplicationRecord
  belongs_to :match
  belongs_to :user
  has_many :comments
  has_many :scores

  valudates :is_home_team, inclusion: {in: [true, false]}
end