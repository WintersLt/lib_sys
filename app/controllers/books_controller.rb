class BooksController < ApplicationController
  def new
  end

def index
      @books = Book.all
        end

def show
      @book = Book.find(params[:id])
        end
  
  def create
    @book = Book.new(book_params)
     
      @book.save
        redirect_to @book
end
 
private
  def book_params
        params.require(:book).permit(:book_name, :isbn, :description, :authors, :status)
          end




end
