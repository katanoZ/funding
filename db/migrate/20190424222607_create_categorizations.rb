class CreateCategorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :categorizations do |t|
      t.references :project, foreign_key: true, null: false
      t.references :category, foreign_key: true, null: false

      t.timestamps
    end
    add_index :categorizations, [:project_id, :category_id], unique: true
  end
end
