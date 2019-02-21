class CreateAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :authors do |t|
      t.string :firstname
      t.string :lastname
      t.timestamp :birthdate

      t.timestamps
    end
  end
end
