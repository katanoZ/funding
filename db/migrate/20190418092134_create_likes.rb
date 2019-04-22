class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :project, foreign_key: true, null: false

      t.timestamps
    end
    add_index :likes, [:project_id, :user_id], unique: true
  end
end
