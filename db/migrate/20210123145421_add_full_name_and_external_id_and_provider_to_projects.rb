class AddFullNameAndExternalIdAndProviderToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :full_name, :string, null: false
    add_column :projects, :external_id, :string, null: false
    add_index :projects, :external_id
    add_column :projects, :provider, :integer, null: false, default: 0
  end
end
