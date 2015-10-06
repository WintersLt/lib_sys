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
	if logged_in_as_admin?	
		@users = User.all	
	else 
	  #Invalid or no cookie recieved in request, flash error
	  redirect_to_home
	end
  end

  def show
    if !logged_in?	
	  #Invalid or no cookie recieved in request, flash error
	  flash.now[:danger] = 'Please login to continue'
	  render 'sessions/new'
	else
	  render 'users'
 	end
  end

  def new
  end

  def view_profile
    if !logged_in?	
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
	elsif params[:search_by] == "isbn"
		@books = Book.where("isbn like ?", "%#{params[:q]}%")
		@query = params[:q]
	elsif params[:search_by] == "author"
		@books = Book.where("authors like ?", "%#{params[:q]}%")
		@query = params[:q]
	elsif params[:search_by] == "description"
		@books = Book.where("description like ?", "%#{params[:q]}%")
		@query = params[:q]
	elsif params[:search_by] == "availability"
		@books = Book.where(status: "Available")
		@query = "All available books"
	elsif params[:search_by] == "unavailability"
		@books = Book.where(status: "Checked out")
		@query = "All unavailable books"
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

  

  def create
    #Logic is to add role - admin or lib_member, if the user already exists
	#an admin can only create new admins(with is_lib_member = false)
	#Sign up form only allow lib_member to be created
	
	@user = User.find_by(email: params[:user][:email])
	user_exists = false
	if @user && logged_in_as_admin? && !@user.is_admin #User exists in db and and admin is trying to create
	  @user.is_admin = true
	elsif @user && !logged_in? && @user.is_admin && !@user.is_lib_member  #User exists and nobody has logged in, it's an lib_member signup for an existing admin
	  @user.is_lib_member = true
	elsif !@user && logged_in_as_admin?  #User does not exist, new admin creation
	  @user = User.new(user_params)
	  @user.is_admin = true
	  @user.is_lib_member = false
	elsif !@user  # new lib_member signup by a completely new user
	  @user = User.new(user_params)
	  @user.is_admin = false
	  @user.is_lib_member = true
	else
	  user_exists = true
	end

	if !user_exists && @user.save
	  flash[:notice]="Sign up successful"
	  #not logging in automatically here, as we dont know what role user wants in  case he has both roles
	  if logged_in_as_admin?
	  	redirect_to current_user
	  else
		redirect_to sessions_new_path
	  end
	else
	  if user_exists
	  	flash.now[:notice]="Signup failed. User with this email already exists"
	  else
	  	flash.now[:notice]="Signup failed. Please retry with correct attributes"
	  end	
	  render "new"
	end
  end

	def destroy
		@user = User.find(params[:id])
		
		if(@user.email == current_user.email)
			flash[:notice] = "You cannot delete yourself."
			redirect_to users_path
			return;
		end

		if(@user.email == "superadmin@admin.com" || @user.name == "Super Admin")
			flash[:notice] = "You cannot delete this admin."
			redirect_to users_path
			return;
		end

		if (@user.is_lib_member)

			@user.is_admin=false			
			result = @user.save
			flash[:notice] = "Admin previliges have been removed for this user- #{result}"

			redirect_to users_path
			return;
		end

		# code to free books that user has borrowed.
		@user.destroy
	
		redirect_to users_path	
	end

  #admin checksout books on behalf of user
  def checkout
	if !logged_in_as_admin?	
	  #Invalid or no cookie recieved in request, flash error
	  redirect_to_home
	end
  end


  private

	def user_params
	 params.require(:user).permit(:name, :email, :password)
	end
end


