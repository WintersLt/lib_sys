require 'alert_mailer'
require 'mail'
class BooksController < ApplicationController
  include SessionsHelper
  def new
    if !logged_in_as_admin?
      redirect_to_home
    end
  end

  def edit
	@book=Book.find(params[:id])
    #render "show"
  end

  def update
	@book =Book.find(params[:id])
	if @book.update_attributes(book_params)
  	  render "show"
	else
	  render 'edit'
   	end
  end

  def index
    if logged_in_as_admin?
      @books = Book.all
    else
      redirect_to_home
    end
  end

  def show
    if logged_in?
	  @book = Book.find(params[:id])
    else
      redirect_to_home
    end
  end

  def create
	if logged_in_as_admin?
	  @book = Book.new(book_params)
	  @book.save
	  redirect_to @book
	else
      redirect_to_home
    end
  end

  def checkout
	@book = Book.find_by(id: params[:id])
	#TODO check if book is nil
  	if logged_in_as_admin?
	  @user = User.find_by(email: params[:email])
	  if !@user	|| !@user.is_lib_member
	    flash[:danger] = "No such library member exists, please retry..."
	    redirect_to @book
		return
	  end
	end

    if logged_in?
	  #TODO what if book is not found ??
	  if logged_in_as_member?
	    @book.update(user_id: current_user.id, status: "Checked out")
	  	history = CheckoutHistory.new(user_id: current_user.id, book_id: @book.id, date_of_issue: Time.now)
	  elsif logged_in_as_admin?
	    @book.update(user_id: @user.id, status: "Checked out")
	    history = CheckoutHistory.new(user_id: @user.id, book_id: @book.id, date_of_issue: Time.now)
	  end
      history.save
	  flash[:danger] = "You have successfully checked out #{@book.book_name}!!"
	  redirect_to current_user
    else
      redirect_to_home
    end
  end

  def destroy
    @book = Book.find(params[:id]);
	#delete checkout history as well, otherwise we end up in foreign key violation in postgres
	CheckoutHistory.where(book_id: @book.id).destroy_all
    @book.destroy
	flash[:danger] = "You have successfully delete #{@book.book_name}!!"
    redirect_to current_user
  end

  def return
    if logged_in?
	  #TODO what if book is not found ??
	  @book = Book.find_by(id: params[:id])
	  @history = CheckoutHistory.where("checkout_histories.book_id = ? and checkout_histories.date_of_return is null", @book.id).first
	  if(@book.status == "Available" || !@history)
	    flash[:notice] = "Book is already with the library"
		redirect_to current_user
		return
	  end
	  # If user is not admin, also check if book is issued to him
	  if logged_in_as_member? && @history.user_id != current_user.id 
		flash[:notice] = "Book is not issued to you, can't return"
		redirect_to current_user
		return
	  end
	  
	  @history.date_of_return = Time.now
	  @book.status = "Available"
	  @book.user_id = nil
	  @history.save
	  @book.save

	  #set email alert here and delete everything from email_alert table for this book
	  #Commenting out email code for production, because heroku gives error otherwise
####  emails = EmailAlert.where("book_id = ?", params[:id]) 
####  #TODO:This can take time, can be done after redirecting
####  emails.each do |email|
####    AlertMailer.alert_email(email).deliver_now
####  end
####  EmailAlert.where(book_id: params[:id]).destroy_all

	  #flash[:notice] = "You have successfully returned #{@book.book_name}!!"
	  flash[:notice] = "You have successfully returned #{@book.book_name}!!"
	  redirect_to current_user
    else
      redirect_to_home
    end
  end

  def set_alert 
    if logged_in_as_member?
	  book = Book.find_by(id: params[:id])

	  if book.user_id == current_user.id
	    flash[:notice] = "You already have the book checked out, alert not set!!"
	  	redirect_to current_user
		return
	  end

	  email_alert = EmailAlert.new(book_id: params[:id], email: current_user.email)
	  if email_alert.save
	    flash[:notice] = "You have successfully set alert!!"
	  else
	    flash[:danger] = "Alert could not be set, something went wrong!!"
	  end
	  redirect_to current_user
	  return
	else
	  redirect_to_home
	end
  end

  def checkout_history
	if !logged_in_as_admin?
	  redirect_to_home
	  return
	end
	if logged_in?
	  #TODO what if book is not found ??
	  @histories = CheckoutHistory.where("checkout_histories.book_id = ?", params[:id]).joins(:book).joins(:user).order(date_of_issue: :desc).select( "checkout_histories.*, users.email as user, books.description as book_description")
	  render 'checkout_history'
	else
	  redirect_to_home
	end
  end


  private

	def book_params
	  params.require(:book).permit(:book_name, :isbn, :description, :authors, :status)
	end
end
