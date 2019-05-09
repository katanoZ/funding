class ChangeCategorizationToProjectCategory < ActiveRecord::Migration[5.2]
  def change
    rename_table :categorizations, :project_categories
  end
end
