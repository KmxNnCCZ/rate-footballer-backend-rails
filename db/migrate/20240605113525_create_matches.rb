class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.integer :match_api_id,    null: false
      t.date :utcDate,            null: false
      t.string :season,           null: false, limit: 5
      t.integer :home_team_score, null: false
      t.integer :away_team_score, null: false
      t.references :home_team, foreign_key: { to_table: :teams }
      t.references :away_team, foreign_key: { to_table: :teams }

      t.timestamps null: false
    end
  end
end
