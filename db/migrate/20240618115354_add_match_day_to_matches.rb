class AddMatchDayToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :matchday, :integer
  end
end
