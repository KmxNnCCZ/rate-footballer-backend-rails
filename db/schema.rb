# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_06_06_112101) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "rate_id", null: false
    t.bigint "user_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rate_id"], name: "index_comments_on_rate_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "lineups", force: :cascade do |t|
    t.boolean "is_home_player", null: false
    t.bigint "match_id"
    t.bigint "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_lineups_on_match_id"
    t.index ["player_id"], name: "index_lineups_on_player_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "match_api_id", null: false
    t.date "utcDate", null: false
    t.string "season", limit: 5, null: false
    t.integer "home_team_score", null: false
    t.integer "away_team_score", null: false
    t.bigint "home_team_id"
    t.bigint "away_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["away_team_id"], name: "index_matches_on_away_team_id"
    t.index ["home_team_id"], name: "index_matches_on_home_team_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "position"
    t.integer "shirt_number", limit: 2
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "rates", force: :cascade do |t|
    t.boolean "is_home_team", null: false
    t.bigint "match_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_rates_on_match_id"
    t.index ["user_id"], name: "index_rates_on_user_id"
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "rate_id", null: false
    t.float "score", null: false
    t.text "assesment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_scores_on_player_id"
    t.index ["rate_id"], name: "index_scores_on_rate_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "short_name", null: false
    t.string "tla", limit: 3, null: false
    t.integer "team_api_id", null: false
    t.string "venue", null: false
    t.string "creset_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
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
  end

  add_foreign_key "comments", "rates"
  add_foreign_key "comments", "users"
  add_foreign_key "lineups", "matches"
  add_foreign_key "lineups", "players"
  add_foreign_key "matches", "teams", column: "away_team_id"
  add_foreign_key "matches", "teams", column: "home_team_id"
  add_foreign_key "players", "teams"
  add_foreign_key "rates", "matches"
  add_foreign_key "rates", "users"
  add_foreign_key "scores", "players"
  add_foreign_key "scores", "rates"
end
