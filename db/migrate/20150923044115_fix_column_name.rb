class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :books, :decription, :description 
  end
end
