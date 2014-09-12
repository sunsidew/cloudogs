class CreateDocsHistories < ActiveRecord::Migration
  def change
    create_table :docs_histories do |t|
      t.integer :docs_id
      t.string :description
      t.integer :prev_history_id
      t.integer :next_history_id
      t.integer :by_user_id
      t.string :by_user_email
    end
  end
end
