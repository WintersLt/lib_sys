class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.string :book_name
      t.string :isbn
      t.text :description
      t.text :authors
      t.text :status

      t.timestamps null: false
    end
  end
end
