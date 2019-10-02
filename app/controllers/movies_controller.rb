class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title,:rating,:ratings, :description, :release_date,:sort,:commit,:back)
    # debug_inspector(params)
  end
  # def session_par
  #   session.require(:movie).permit(:rate,:sorting)
  #   debug_inspector(session)
  # end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_by=nil #variable that sorts the data 
    @rate=nil #variable that filters data based on variable
    redirect=false
    logger.debug(flash[:notice].inspect)
    
    if params[:sort]#sorting variable sent from view explicitly
      @sort_by=params[:sort]
      session[:sort]=params[:sort]#store this value in session hash
    elsif session[:sort]#if variable not sent explicitly use values from sessions hash
      @sort_by=session[:sort]
      redirect=true
    end
    if params[:rating]#filtering variable sent from view explicitly
      @rate=params[:rating]
      session[:rate]=params[:rating]#store these values in session hash
    elsif session[:rate]
      @rate=session[:rate]#if variable not sent explicitly use values from sessions hash
      session.clear
      redirect=true
    end
    
    if params[:commit]=='Refresh' and params[:rating].nil? # if refresh pressed withou ticking any box
      @rate=nil
      session[:rate]=nil
    end  
    logger.debug(flash[:notice].inspect)
    
    if redirect # whenver coming back to main movie page we recall with the saved session variables 
      logger.debug('hey')
      flash.keep
      logger.debug(flash[:notice].inspect)
      redirect_to movies_path :sort =>@sort_by, :rating => @rate
    end
    
    if @sort_by or @rate #if variables present for sorting or filtering
      @movies=Movie.with_rating(@rate).order(@sort_by)
      @sort_v=@sort_by
      @all_ratings=Movie.all_rating()
    
    else#no sorting or filtering required
      @movies=Movie.all
      @sort_by=nil
      @rate=nil
      # @movies=@movie.order(params[:sort])
      @all_ratings=Movie.all_rating()
    end
    @rate_av=@movies.distinct.pluck('rating')
    return session[:rate]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
    
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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

