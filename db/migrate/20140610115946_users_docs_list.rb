class UsersDocsList < ActiveRecord::Migration
  def self.up
    create_table :docs_users, :id => false do |t|
      t.integer :user_id, :null => false
      t.integer :doc_id, :null => false
    end

    add_index :docs_users, [:user_id, :doc_id], :unique => true
  end

  def self.down
  	remove_index :docs_users, :column => [:user_id, :doc_id]
    drop_table :docs_users
  end
end
