class CreateScores < ActiveRecord::Migration[7.1]
  def change
    create_table :scores do |t|
      t.references :player, null: false, foreign_key: true
      t.references :rate, null: false, foreign_key: true
      t.float :score, null: false
      t.text :assesment

      t.timestamps null: false
    end
  end
end
