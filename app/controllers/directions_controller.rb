require 'json'
require 'ostruct'

class DirectionsController < ApplicationController

  # Direction method ==> return no stations if @query=0
  def directions
    @query = 0
  end

  #method to retrieve the directions for the input ==> Show response on same page
  def search_directions
    @query = 1
    @error = 0
    @departure_address = params[:departure_address]
    @arrival_address = params[:arrival_address]

    if @departure_address != "" && @arrival_address != ""
      url_safe_dep = URI.encode(@departure_address)
      url_safe_arr = URI.encode(@arrival_address)

      apiLink = "https://maps.googleapis.com/maps/api/directions/json?origin=#{url_safe_dep}&destination=#{url_safe_arr}&mode=transit&alternatives=true"

      @directions = JSON.parse(open(apiLink).read, object_class: OpenStruct)

      if @directions.status == "OK"
        @routes = @directions.routes
        @error = 0
      else
        @message = "No station found, try again"
        @error = 1
      end
    else
      @message = "Please enter a value for departure and arrival address"
      @error = 1
    end

      #render :json => @routes
      render 'directions'
  end

end
