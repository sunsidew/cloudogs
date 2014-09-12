class CreateDialogs < ActiveRecord::Migration
  def change
    create_table :dialogs do |t|
      t.integer :docs_id
      t.string :filename
    end
  end
end
