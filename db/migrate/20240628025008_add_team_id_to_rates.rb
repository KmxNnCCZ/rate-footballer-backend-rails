class AddTeamIdToRates < ActiveRecord::Migration[7.1]
  def change
    add_reference :rates, :team, foreign_key: true, null: false
  end
end
