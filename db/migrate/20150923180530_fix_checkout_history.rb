class FixCheckoutHistory < ActiveRecord::Migration
  def change
  	rename_column :checkout_histories, :data_of_issue, :date_of_issue
  end
end
