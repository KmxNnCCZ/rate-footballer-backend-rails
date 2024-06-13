=begin
  t.boolean "is_home_player", null: false
  t.bigint "match_id"
  t.bigint "player_id"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["match_id"], name: "index_lineups_on_match_id"
  t.index ["player_id"], name: "index_lineups_on_player_id"
=end

class Lineup < ApplicationRecord
  belongs_to :match
  belongs_to :player

  validates :is_home_player, inclusion: {in: [true, false]}
end
