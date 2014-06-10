class CreateDocs < ActiveRecord::Migration
  def change
    create_table :docs do |t|

      t.string :title
      t.string :filename
      t.integer :now_history_id
      t.integer :owner_user_id

      t.timestamps
    end
  end
end
