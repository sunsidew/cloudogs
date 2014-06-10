class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login_email
      t.string :login_crypt_pw
      t.string :username

      t.timestamps
    end
  end
end
