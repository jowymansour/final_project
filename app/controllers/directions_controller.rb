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
    @type_transport = params[:type_transport]
    @preferred = params[:preferred]
    apikey = "AIzaSyCDeWWmT-KYmsgSz9d2vCy0KcOmJe114y4"

    if @departure_address != "" && @arrival_address != ""
      url_safe_dep = URI.encode(@departure_address)
      url_safe_arr = URI.encode(@arrival_address)

    if !@type_transport.nil? || !@preferred.nil?
      url_safe_typ = URI.encode(@type_transport)
      url_safe_pref = URI.encode(@preferred)
    else
      apiLink = "https://maps.googleapis.com/maps/api/directions/json?origin=#{url_safe_dep}&destination=#{url_safe_arr}&mode=transit&alternatives=true&transit_mode=#{@url_safe_typ}&transit_routing_preference=#{url_safe_pref}&key=#{apikey}"
    end

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

  def schedule
    @type_transport = params["type"]
    stop = params["stop"]
    line = params["line"]
    @error = 0

    #Si c'est un train!
    if @type_transport == "SUBWAY"
      @line_db = Transportation.find_by(:route_long_name => line)
      stop_train = stop.split(' (')[0]

      @stop_db = TrainStop.where("station_name ILIKE ?",  "%#{stop_train}%").where(@line_db.route_id.upcase => "t").first

      if @stop_db.nil?
        @message = "No Prediction can be found for this stop #{stop_train}"
        @error = 1
      else
        #@train_prediction = train_api(stop_db.MAP_ID)
        #render :json => @train_prediction
        @train_prediction = train_api(@stop_db.MAP_ID)["ctatt"]["eta"]
      end

    #Si c'est un bus
    elsif @type_transport == "BUS"

    else
      @message = "No Prediction for this line"
      @error = 1
    end
  end



  private
  #Private method to retrieve prediction of specific train station
  def train_api(mapid)
    url_safe_mapid = URI.encode(mapid)
    apiKey = "73b6a68e9e4f450792ba730b84d8c506"
    apiLink = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{apiKey}&mapid=#{url_safe_mapid}"
    apiResults = open(apiLink).read
    return Hash.from_xml(apiResults)
  end

  #Private method to retrieve prediction of specific bus station
  def bus_api(stpid, route)
    url_safe_stpid = URI.encode(stpid)
    url_safe_route = URI.encode(route)
    apiKey = "UPGw2J5PBxNnF967CAMyHygeB"
    apiLink = "http://www.ctabustracker.com/bustime/api/v1/getpredictions?key=#{apiKey}&stpid=#{url_safe_stpid}&rt=#{url_safe_route}"
    apiResults = open(apiLink).read
    apiJSON = Hash.from_xml(apiResults)
    return JSON.parse(apiJSON, object_class: OpenStruct)
  end

end
