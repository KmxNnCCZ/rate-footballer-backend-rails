class RemoveIsHomeTeamFromRates < ActiveRecord::Migration[7.1]
  def change
    remove_column :rates, :is_home_team
  end
end
