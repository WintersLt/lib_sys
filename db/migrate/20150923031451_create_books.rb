class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string:book_name
      t.integer:isbn
      t.text:decription
      t.text:authors
      t.text:status
      t.timestamps null: false
    end
  end
end
