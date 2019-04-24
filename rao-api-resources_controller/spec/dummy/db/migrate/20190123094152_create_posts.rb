class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :author, foreign_key: true
      t.string :firstname
      t.string :lastname
      t.boolean :visible

      t.timestamps
    end
  end
end
