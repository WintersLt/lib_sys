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


	def index
		if(!current_user)	
			#Invalid or no cookie recieved in request, flash error
			flash.now[:danger] = 'Please login to continue'
			render 'sessions/new'
		else
			@users = Users.all	
		end
	
	end
  def show
	    if(!current_user)	
	#Invalid or no cookie recieved in request, flash error
	flash.now[:danger] = 'Please login to continue'
	render 'sessions/new'
	else
	render 'users'
	end
  end

	def new
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

def index
  @users=User.all
end

def create
	  @user=User.new(user_params)

	if current_user 
		@user.is_lib_member=true
	  	@user.is_admin=true;

		if @user.save
		 flash[:notice]="Admin Created successful."		
		 redirect_to users_path
		 return;
		else
	 	  flash[:notice]="Signup failed. Please enter correct values."
	 	  render "new"
		  return;
	 	end	
	else
		@user.is_lib_member=true
	 	 @user.is_admin=false
	end
	  
	  if @user.save
	 flash[:notice]="SignUp successful"
	 log_in @user
	 redirect_to @user
	 else
	 flash[:notice]="Signup failed. Please enter correct values."
	 render "new"
	 end
end


	def destroy
		@user = User.find(params[:id])

		# code to free books that user has borrowed.
		@user.destroy
	
		redirect_to users_path	
	end

  private
    def user_params
     params.require(:user).permit(:name, :email, :password)
    end
end


