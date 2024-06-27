class RenameAssesmentColumnToScores < ActiveRecord::Migration[7.1]
  def change
    rename_column :scores, :assesment, :assessment
  end
end
