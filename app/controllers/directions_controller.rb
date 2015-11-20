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
    bus_transit = params[:bus_transit]
    train_transit = params[:train_transit]
    metra_transit = params[:metra_transit]
    @preferred = params[:preferred]
    apikey = "AIzaSyCDeWWmT-KYmsgSz9d2vCy0KcOmJe114y4"

    if @departure_address != "" && @arrival_address != ""
      url_safe_dep = URI.encode(@departure_address)
      url_safe_arr = URI.encode(@arrival_address)
      @type_transport = ''

    if !bus_transit.nil?
      @type_transport = bus_transit
    end

    if !train_transit.nil?
      @type_transport += "|" + train_transit
    end

    if !metra_transit.nil?
      @type_transport += "|" + metra_transit
    end

    if !@type_transport != '' && !@preferred.nil? && @preferred != ""
      url_safe_typ = URI.encode(@type_transport)
      url_safe_pref = URI.encode(@preferred)
      apiLink = "https://maps.googleapis.com/maps/api/directions/json?origin=#{url_safe_dep}&destination=#{url_safe_arr}&mode=transit&alternatives=true&transit_mode=#{@url_safe_typ}&transit_routing_preference=#{url_safe_pref}&key=#{apikey}"

    elsif !@type_transport != ''
      url_safe_typ = URI.encode(@type_transport)
      apiLink = "https://maps.googleapis.com/maps/api/directions/json?origin=#{url_safe_dep}&destination=#{url_safe_arr}&mode=transit&alternatives=true&transit_mode=#{url_safe_typ}&key=#{apikey}"

    elsif !@preferred.nil? && @preferred != ""
      url_safe_pref = URI.encode(@preferred)
      apiLink = "https://maps.googleapis.com/maps/api/directions/json?origin=#{url_safe_dep}&destination=#{url_safe_arr}&mode=transit&alternatives=true&transit_routing_preference=#{url_safe_pref}&key=#{apikey}"
    else
      apiLink = "https://maps.googleapis.com/maps/api/directions/json?origin=#{url_safe_dep}&destination=#{url_safe_arr}&mode=transit&alternatives=true"
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
    latitude = params["lat"]
    longitude = params["lng"]
    @error = 0

    #IF it is a train
    if @type_transport == "SUBWAY"
      @line_db = Transportation.find_by(:route_long_name => line)
      stop_train = stop.split(' (')[0]

      @stop_db = TrainStop.where("station_name ILIKE ?",  "%#{stop_train}%").where(@line_db.route_id => "t").first

      if @stop_db.nil?
        @message = "No Prediction can be found for this stop #{stop_train}"
        @error = 1
      else
        @train_prediction = train_api(@stop_db.MAP_ID)["ctatt"]["eta"]
      end

    #If it is a bus
    elsif @type_transport == "BUS"
      directions = bus_api_getdirections(line)["bustime_response"]["dir"]
      if directions.nil?
        @message = "No Prediction for this line"
        @error = 1
      else

        stop_json = bus_api_getstop(line, directions, latitude, longitude)
        if stop_json == 0
          @error = 1
          @message = "No Prediction can be found for this stop"
        else
          @stop_id = stop_json["stpid"]
          @line = line
          @bus_prediction = bus_api(@stop_id, line)["bustime_response"]["prd"]
        end
      end
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
    return Hash.from_xml(apiResults)
  end

  #Private method to retrieve bus directions
  def bus_api_getdirections(route)
    url_safe_route = URI.encode(route)
    apiKey = "UPGw2J5PBxNnF967CAMyHygeB"
    apiLink = "http://www.ctabustracker.com/bustime/api/v1/getdirections?key=#{apiKey}&rt=#{url_safe_route}"
    apiResults = open(apiLink).read
    return Hash.from_xml(apiResults)
  end

  #Private method to retrieve bus stop ID
  def bus_api_getstop(route, directions, latitude, longitude)

    url_safe_route = URI.encode(route)
    apiKey = "UPGw2J5PBxNnF967CAMyHygeB"

    directions.each do |direction|
      url_safe_direction = URI.encode(direction)
      apiLink = "http://www.ctabustracker.com/bustime/api/v1/getstops?key=#{apiKey}&dir=#{url_safe_direction}&rt=#{url_safe_route}"
      apiResults = Hash.from_xml(open(apiLink).read)
      stops = apiResults["bustime_response"]["stop"]
      stops.each do |stop|
        if (stop["lat"][0, 6] == latitude[0, 6] && stop["lon"][0, 7] == longitude[0, 7])
           return stop
        end
      end
    end
    return 0
  end

end
