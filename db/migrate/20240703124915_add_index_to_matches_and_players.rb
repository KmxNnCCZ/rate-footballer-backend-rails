class AddIndexToMatchesAndPlayers < ActiveRecord::Migration[7.1]
  def change
    add_index :matches, :match_api_id
    add_index :players, :player_api_id
  end
end
