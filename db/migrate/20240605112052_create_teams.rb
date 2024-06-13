class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :name,          null: false
      t.string :short_name,    null: false
      t.string :tla,           null: false, limit: 3
      t.integer :team_api_id,  null: false
      t.string :venue,         null: false
      t.string :creset_url,    null: false

      t.timestamps null: false
    end
  end
end
