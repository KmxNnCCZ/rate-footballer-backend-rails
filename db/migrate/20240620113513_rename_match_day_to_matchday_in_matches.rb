class RenameMatchDayToMatchdayInMatches < ActiveRecord::Migration[7.1]
  def change
    rename_column :matches, :match_day, :matchday
  end
end
