class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.string :position
      t.integer :shirt_number, limit: 2
      t.references :team, foreign_key: true

      t.timestamps null: false
    end
  end
end
