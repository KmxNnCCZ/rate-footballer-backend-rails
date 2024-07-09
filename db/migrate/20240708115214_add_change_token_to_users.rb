class AddChangeTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :change_token, :string
    add_column :users, :change_token_sent_at, :datetime
  end
end
