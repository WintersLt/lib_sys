module SessionsHelper

  # Logs in the given user.
  # Stores the id as sess id, this id is encryted and sent as cookie
  def log_in(user, role)
    session[:user_id] = user.id
	#storing role in session to allow same user to login as admin/lib_member
    session[:is_admin] = ("administrator" == role.downcase)
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_out
    session.delete(:user_id)
    session.delete(:is_admin)
    @current_user = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def logged_in_as_admin?
    current_user && current_user.is_admin && session[:is_admin]
  end

  def logged_in_as_member?
    current_user && current_user.is_lib_member && !session[:is_admin]
  end

  def redirect_to_home
flash[:danger] = 'Something went wrong, please retry'
if logged_in?
  redirect_to current_user
else
  redirect_to root_path
end
  end	

end
