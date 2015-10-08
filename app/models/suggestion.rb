class Suggestion < ActiveRecord::Base
validates  :isbn, uniqueness: true
end
