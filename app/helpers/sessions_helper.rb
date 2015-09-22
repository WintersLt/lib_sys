module SessionsHelper

  # Logs in the given user.
  # Stores the id as sess id, this id is encryted and sent as cookie
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def logged_in_as_admin?
    current_user && current_user.is_admin
  end
end
