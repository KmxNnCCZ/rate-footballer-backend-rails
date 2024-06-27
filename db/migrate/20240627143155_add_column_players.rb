class AddColumnPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :player_api_id, :integer
  end
end
