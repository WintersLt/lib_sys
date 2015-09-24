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
      	render 'sessions/new'
	else
	  	render 'users'
	end
  end

  def search
    if(!current_user)	
		#Invalid or no cookie recieved in request, flash error
      	flash.now[:danger] = 'Please login to continue'
      	render 'sessions/new'
	elsif params[:search_by] == "book_name"
		#TODO put checks here that field should not be empty
		#TODO page results here, make it case insensitive
		@books = Book.where("book_name like ?", "%#{params[:q]}%")
		@query = params[:q]
	  	#render 'search'
	elsif params[:search_by] == "book_name"
		#TODO put checks here that field should not be empty
		#TODO page results here
		@books = Book.where("isbn like ?", "%#{params[:q]}%")
		@query = params[:q]
	  	#render 'search'
	else
		flash.now[:danger] = "Search failed, retry remember to select a criteria."
		render 'users'

	end
  end

  def checkout_history
  	if logged_in_as_member?
	  #TODO what if book is not found ??
	  @histories = CheckoutHistory.where("checkout_histories.user_id = ?", current_user.id).joins(:book).joins(:user).order(date_of_issue: :desc).select( "checkout_histories.*, books.book_name as book_name, books.description as book_description")
	  render 'checkout_history'
	else
	  redirect_to_home
	end
  end

end
