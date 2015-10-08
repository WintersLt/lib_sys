class CreateEmailAlerts < ActiveRecord::Migration
  def change
    create_table :email_alerts do |t|
      t.text :email

      t.timestamps null: false
    end
  end
end
