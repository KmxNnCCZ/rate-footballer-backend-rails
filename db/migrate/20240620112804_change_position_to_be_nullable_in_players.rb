class ChangePositionToBeNullableInPlayers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :players, :position, true
  end
end
