=begin
  t.string "name"
  t.string "position"
  t.integer "shirt_number", limit: 2
  t.bigint "team_id"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["team_id"], name: "index_players_on_team_id"
=end

class Player < ApplicationRecord
  has_many :lineups
  has_many :scores
  belongs_to :team

  validates :name, presence: true
  validates :position, presence: true
  validates :shirt_number, presence: true, length: { in: 1..2 }
end
