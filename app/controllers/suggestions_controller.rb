class SuggestionsController < ApplicationController
  include SessionsHelper
  def new    
  end

  def edit
	@suggestion =Suggestion.find(params[:id])
    #render "show"
  end

  def update
	@suggestion =Suggestion.find(params[:id])
	if @suggestion.update_attributes(suggestion_params)
		flash[:notice] = "Book suggestion has been approved."

		# step1 - insert a book

		@book = Book.new(suggestion_params)
	  	@book.save	

		# step2 - delete suggestion
		
		@suggestion.destroy	

  	  render "show"
	else
	  render 'edit'
   	end
  end

  def index
    if logged_in_as_admin?
      @suggestions = Suggestion.all
    else
      redirect_to_home
    end
  end

  def show
    if logged_in?
	  @suggestion = Suggestion.find(params[:id])
    else
      redirect_to_home
    end
  end

  def create
	  @suggestion = Suggestion.new(suggestion_params)
	  @suggestion.save
	  redirect_to @suggestion
  end

  
  
  def destroy
    @suggestion = Suggestion.find(params[:id]);
	#delete checkout history as well, otherwise we end up in foreign key violation in postgres
    @suggestion.destroy
    redirect_to current_user
  end

  
  private

	def suggestion_params
	  params.require(:suggestion).permit(:book_name, :isbn, :description, :authors, :status)
	end
end
