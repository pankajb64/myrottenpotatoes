class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
	if params[:sort_by] == nil && session[:sort_by] != nil
		@sort_by = params[:sort_by] = session[:sort_by]
		redirect = true
	else
		session[:sort_by] = @sort_by = params[:sort_by]
		redirect = false
	end

	@ratings = {}
	@all_ratings = Movie.ratings
	
	if session[:keys] == nil
		session[:keys] = @all_ratings
		redirect = true
	end
		
	if params[:ratings] == nil && params[:commit] == nil # form ain't submitted
		keys = session[:keys]
		if session[:ratings] == nil
			redirect = false
		else
			@ratings = session[:ratings]
			redirect = true
		end		
	elsif  params[:ratings] == nil && params[:commit] != nil # form submitted but no rating checked
		keys = @all_ratings
		session[:ratings] =  nil
		redirect = false
	else
		session[:ratings] = @ratings = params[:ratings]	
		keys = params[:ratings].keys
		redirect = false
	end	

	session[:keys] = keys
	
	if redirect 
		flash.keep
		redirect_to movies_path(:sort_by => @sort_by, :ratings => @ratings)
	end
		
	@movies = Movie.where( "rating IN ( :keys )", :keys => keys).order(@sort_by)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
