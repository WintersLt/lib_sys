class SessionsController < ApplicationController
  include SessionsHelper
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
	  #Check user privelage here and flash error if improper
	  #TODO check if it can be defined as enum. Test cases for this

	  if params[:session][:user_type].downcase == "select user type"
      	flash.now[:error] = 'You must select a user type, kindly retry with correct user type'
      	render 'new'
	  elsif params[:session][:user_type].downcase == "administrator" && !(user.is_admin)
     	flash.now[:error] = 'You do not have admin privilages, kindly retry with correct user type'
     	render 'new'
	 else
        log_in user
        redirect_to user
	  end
    else
      #flash.now[:danger] = 'Improper credentials, kindly retry with correct credentials'
      flash.now[:error] = 'Improper credentials, kindly retry with correct credentials'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end