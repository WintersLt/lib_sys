class EmailAlert < ActiveRecord::Migration
  def change
    add_reference :email_alerts, :book, index: true, foreign_key: true
  end
end
