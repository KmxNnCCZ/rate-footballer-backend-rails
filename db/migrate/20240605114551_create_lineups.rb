class CreateLineups < ActiveRecord::Migration[7.1]
  def change
    create_table :lineups do |t|
      t.boolean :is_home_player, null: false
      t.references :match, foreign_key: true
      t.references :player, foreign_key: true

      t.timestamps null: false
    end
  end
end
