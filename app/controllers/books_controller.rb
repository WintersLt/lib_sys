class BooksController < ApplicationController
  def new
  end
def create
    @book = Book.new(params[:book])
     
      @book.save
        redirect_to @book
end


end
