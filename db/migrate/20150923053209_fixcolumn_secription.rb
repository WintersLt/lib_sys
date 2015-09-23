class FixcolumnSecription < ActiveRecord::Migration
  def change
rename_column :books, :secription, :description
  end
end
