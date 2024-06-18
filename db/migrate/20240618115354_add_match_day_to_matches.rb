class AddMatchDayToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :match_day, :integer
  end
end
