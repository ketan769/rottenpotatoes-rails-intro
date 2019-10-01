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
    @sort_by=nil
    @rate=nil
    redirect=false
    logger.debug(flash[:notice].inspect)
    
    if params[:sort]
      @sort_by=params[:sort]
      session[:sort]=params[:sort]
    elsif session[:sort]
      @sort_by=session[:sort]
      redirect=true
    end
    if params[:rating]
      @rate=params[:rating]
      session[:rate]=params[:rating]
    elsif session[:rate]
      @rate=session[:rate]
      session.clear
      redirect=true
    end
    
    if params[:commit]=='Refresh' and params[:rating].nil?
      @rate=nil
      # logger.debug(@rate.inspect)
      session[:rate]=nil
    end  
    logger.debug(flash[:notice].inspect)
    if redirect
      logger.debug('hey')
      flash.keep
      logger.debug(flash[:notice].inspect)
      redirect_to movies_path :sort =>@sort_by, :rating => @rate
    end  
    if @sort_by or @rate
      @movies=Movie.with_rating(@rate).order(@sort_by)
      @sort_v=@sort_by
      @all_ratings=Movie.all_rating()
    else
      @movies=Movie.all
      @sort_by=nil
      @rate=nil
      # @movies=@movie.order(params[:sort])
      @all_ratings=Movie.all_rating()
    end
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

