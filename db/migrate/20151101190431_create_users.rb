class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :rember_digest
      t.string :provider
      t.string :uid
      t.string :oauth_token
      t.string :oauth_expires_at

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end
