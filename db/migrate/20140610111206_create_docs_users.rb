class CreateDocsUsers < ActiveRecord::Migration
  def change
    create_table :docs_users do |t|
      t.integer :doc_id
      t.integer :user_id

      t.timestamps
    end
  end
end
