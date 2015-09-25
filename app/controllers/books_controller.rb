class BooksController < ApplicationController
  include SessionsHelper
  def new
if !logged_in_as_admin?
 redirect_to_home
nd
  end

def edit
  @book=Book.find(params[:id])
render "edit"
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
if logged_in_as_member?
  #TODO what if book is not found ??
  @book = Book.find_by(id: params[:id])
  @book.update(user_id: current_user.id, status: "Checked out")
  history = CheckoutHistory.new(user_id: current_user.id, book_id: @book.id, date_of_issue: Time.now)
 history.save
      flash[:danger] = "You have successfully checked out #{@book.book_name}!!"
      redirect_to current_user
else
  redirect_to_home
end
  end

  def destroy
@book = Book.find(params[:id]);
@book.destroy

redirect_to books_path

  end

  private
def book_params
  params.require(:book).permit(:book_name, :isbn, :description, :authors, :status)
end
end
