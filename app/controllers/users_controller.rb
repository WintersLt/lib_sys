#      users GET    /users(.:format)          users#index
#            POST   /users(.:format)          users#create
#   new_user GET    /users/new(.:format)      users#new
#  edit_user GET    /users/:id/edit(.:format) users#edit
#       user GET    /users/:id(.:format)      users#show
#            PATCH  /users/:id(.:format)      users#update
#            PUT    /users/:id(.:format)      users#update
#            DELETE /users/:id(.:format)      users#destroy

class UsersController < ApplicationController
  include SessionsHelper
  def show
    if(!current_user)	
		#Invalid or no cookie recieved in request, flash error
      	flash.now[:danger] = 'Please login to continue'
      	render 'Sessions#new'
	end
	render 'user'
  end
end
