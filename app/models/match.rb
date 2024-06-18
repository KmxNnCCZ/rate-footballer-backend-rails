=begin
  t.integer "match_api_id", null: false
  t.date "utcDate", null: false
  t.string "season", limit: 5, null: false
  t.integer "home_team_score", null: false
  t.integer "away_team_score", null: false
  t.bigint "home_team_id"
  t.bigint "away_team_id"
  # t.integer "match_day"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["away_team_id"], name: "index_matches_on_away_team_id"
  t.index ["home_team_id"], name: "index_matches_on_home_team_id"
=end

class Match < ApplicationRecord
  has_many :lineups
  has_many :rates
  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id'

  validates :match_api_id, presence: true, numericality: { only_integer: true }
  validates :utcDate, presence: true
  validates :season, presence: true, length: { is: 5 }
  validates :home_team_score, presence: true, numericality: { only_integer: true }
  validates :away_team_score, presence: true, numericality: { only_integer: true }
  validates :match_day, presence: true, numericality: { only_integer: true }, length: { in: 1..2  }

end
