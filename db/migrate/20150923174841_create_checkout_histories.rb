class CreateCheckoutHistories < ActiveRecord::Migration
  def change
    create_table :checkout_histories do |t|
      t.datetime :data_of_issue
      t.datetime :date_of_return

      t.timestamps null: false
    end
  end
end
