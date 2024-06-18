class RenameCresetUrlCloumnToTeams < ActiveRecord::Migration[7.1]
  def change
    rename_column :teams, :creset_url, :crest_url
  end
end
