=begin
  t.string "name", null: false
  t.string "short_name", null: false
  t.string "tla", limit: 3, null: false
  t.integer "team_api_id", null: false
  t.string "venue", null: false
  t.string "creset_url", null: false
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
=end


class Team < ApplicationRecord
  has_many :home_matches, class_name: 'Match', foreign_key: 'home_team_id'
  has_many :away_matches, class_name: 'Match', foreign_key: 'away_team_id'
  has_many :players

  validates :name, presence: true
  validates :short_name, presence: true
  validates :tla, presence: true, length: { is: 3 }
  validates :team_api_id, presence: true, numericality: { only_integer: true }
  validates :venue, presence: true
  validates :creset_url, presence: true, url: { allow_blank: true }
end
