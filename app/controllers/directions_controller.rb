class DirectionsController < ApplicationController

  # Direction method ==> return no stations if @query=0
  def directions
    @query = 0
  end

  #method to retrieve the directions for the input ==> Show response on same page
  def search_directions
    @query = 1
    @search_query = params[:search_stations]
    if @search_query.blank?
      @message = "No station found, try again"
    end

    render 'stations'
  end

end
