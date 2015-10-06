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
	  end
	  # If user is not admin, also check if book is issued to him
	  if logged_in_as_member? && @history.user_id != current_user.id 
		flash[:notice] = "Book is not issued to you, can't return"
		redirect_to current_user
	  end
	  
	  @history.date_of_return = Time.now
	  @book.status = "Available"
	  @history.save
	  @book.save

	  flash[:danger] = "You have successfully returned #{@book.book_name}!!"
	  redirect_to current_user
    else
      redirect_to_home
    end
  end


  private

	def book_params
	  params.require(:book).permit(:book_name, :isbn, :description, :authors, :status)
	end
end
