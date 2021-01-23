class CreateOauthAuthorizations < ActiveRecord::Migration[6.0]
  def change
    create_table :oauth_authorizations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.json :info, default: {}
      t.json :credentials, default: {}, null: false
      t.json :extra, default: {}

      t.timestamps
    end
  end
end
