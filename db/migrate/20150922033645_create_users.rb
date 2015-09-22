class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :is_admin
      t.boolean :is_lib_member
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
