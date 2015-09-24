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

  def view_profile
    if(!current_user)	
		#Invalid or no cookie recieved in request, flash error
      	flash.now[:danger] = 'Please login to continue'
      	render 'sessions/new'
	else
	  	render 'view_profile'
	end
  end

  def edit
    if(!current_user)	
		#Invalid or no cookie recieved in request, flash error
      	flash.now[:danger] = 'Please login to continue'
      	render 'sessions/new'
	else
        @user = User.find_by(id: session[:user_id])
	end
  end

  def update
    @user = User.find_by(id: session[:user_id])
    if @user.update_attributes(params.require(:user).permit(:name, :email))
	 # @current_user = User.find_by(id: session[:user_id])
      flash.now[:notice] = 'Profile updated successfully'
	  redirect_to users_view_profile_path
    else
      flash.now[:danger] = 'Profile update failed'
	  redirect_to users_edit_path
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
		flash.now[:danger] = "Search failed, remember to select a criteria."
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

  def change_pass
    if(!current_user)	
		#Invalid or no cookie recieved in request, flash error
      	flash.now[:danger] = 'Please login to continue'
      	render 'sessions/new'
	else
        @user = User.find_by(id: session[:user_id])
	end
  end

  def update_pass
    @user = User.find_by(id: session[:user_id])
	#@user.password = params[:user][:current_password]
	#authenticate using existing passowrd 
    if @user && @user.authenticate(params[:user][:current_password])
	  @user.password = params[:user][:new_password]
	  @user.password_confirmation = params[:user][:confirm_new_password]
	  if @user.save
      	flash[:danger] = 'Password updated successfully'
	  	redirect_to users_view_profile_path
	  else
      	flash[:danger] = 'Password update failed'
	  	redirect_to users_change_pass_path
	  end
    else
      flash[:danger] = "Old password <#{params[:user][:current_password]}> is wrong"

	  redirect_to users_change_pass_path
    end
  end

  def index
	@users=User.all
  end

  def create
	@user=User.new(user_params)
	@user.is_lib_member=true
	@user.is_admin=false
	if @user.save
	  flash[:notice]="SignUp successful"
	  log_in @user
	  redirect_to @user
	  #redirect_to @user
   else
     flash[:notice]="Signup failed. Please input values in correct form"
     render "new"
   end
  end
  private
    def user_params
     params.require(:user).permit(:name, :email, :password)
    end
end


