# typed: true
class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :projects, :token, unique: true
  end
end
