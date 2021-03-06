class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description
      t.integer :price, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
    add_index :projects, :name, unique: true
  end
end
