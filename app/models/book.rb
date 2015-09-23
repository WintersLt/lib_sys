class Book < ActiveRecord::Base
  belongs_to :user 
  has_many :checkout_histories
end
