class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :access_token
      t.string :refresh_token
      t.datetime :token_expires_at

      t.timestamps
    end
  end
end
