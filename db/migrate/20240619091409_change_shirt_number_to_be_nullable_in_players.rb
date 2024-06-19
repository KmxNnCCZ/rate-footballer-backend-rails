class ChangeShirtNumberToBeNullableInPlayers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :players, :shirt_number, true
  end
end
