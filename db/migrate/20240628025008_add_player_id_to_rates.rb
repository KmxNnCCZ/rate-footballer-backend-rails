class AddPlayerIdToRates < ActiveRecord::Migration[7.1]
  def change
    add_reference :rates, :players, foreign_key: true
    remove_column :rates, :is_home_team
  end
end
