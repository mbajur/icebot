# typed: false
class CreateMetrics < ActiveRecord::Migration[6.0]
  def change
    enable_extension "hstore"

    create_table :metrics do |t|
      t.references :project, null: false, foreign_key: true
      t.jsonb :body
      t.string :branch

      t.timestamps
    end
  end
end
