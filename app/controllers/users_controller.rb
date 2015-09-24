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
#TODO page results here
@books = Book.where("title like ?", "%#{params[:q]}%")
@query = params[:q]
#render 'search'
end
  end


def index
      @users = User.all
 end

=begin
def show
  @user = User.find(params[:id])#  @users=User.all
end
=end
 def create
@user = User.new(user_params)
@user.is_lib_member=true
@user.is_admin=false
if @user.save
flash[:notice]="SignUp successful"
log_in @user
redirect_to @user
#redirect_to @user
else
  flash[:notice]="Signup failed. Please input values in correct form"
#flash[:color]= "valid"
  render "new"
  #redirect_to @new_user
end
 end

 private

 def user_params
  params.require(:user).permit(:name, :email, :password)
  end

end
