class AddForeignKeyToScores < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :scores, :rates
    add_foreign_key :scores, :rates, on_delete: :cascade
  end
end
