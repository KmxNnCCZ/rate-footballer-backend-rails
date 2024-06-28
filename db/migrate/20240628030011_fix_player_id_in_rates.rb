class FixPlayerIdInRates < ActiveRecord::Migration[7.1]
  def change
    remove_reference :rates, :player, foreign_key: true
    add_reference :rates, :team, foreign_key: true, null: false
  end
end
