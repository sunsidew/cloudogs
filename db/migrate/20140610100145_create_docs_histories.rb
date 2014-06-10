class CreateDocsHistories < ActiveRecord::Migration
  def change
    create_table :docs_histories do |t|
      t.integer :docs_id
      t.string :description
      t.integer :prev_histroy_id
      t.integer :next_histroy_id
      t.integer :by_user_id
      t.string :by_user_email

      t.timestamps
    end
  end
end
