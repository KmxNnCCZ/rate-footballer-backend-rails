=begin
  t.bigint "player_id", null: false
  t.bigint "rate_id", null: false
  t.float "score", null: false
  t.text "assesment"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["player_id"], name: "index_scores_on_player_id"
  t.index ["rate_id"], name: "index_scores_on_rate_id"
=end

class Score < ApplicationRecord
  belongs_to :player
  belongs_to :rate

  validates :score, numericality: { 
                      greater_than_or_equal_to: 0.0, 
                      less_than_or_equal_to: 10.0 
                    }
  validates :assesment, presence: true
end
