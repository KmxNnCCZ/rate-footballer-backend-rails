class CreateRates < ActiveRecord::Migration[7.1]
  def change
    create_table :rates do |t|
      t.boolean :is_home_team, null: false
      t.references :match, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
