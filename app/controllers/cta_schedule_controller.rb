require 'open-uri'

class CtaScheduleController < ApplicationController
  def new_search
  end

  def transportation_request
    line_request = params[:line]
    lines =  Transportation.where("route_long_name like ? OR route_short_name like ?", "%#{line_request}%", "%#{line_request}%")

    render :json => lines
  end

  def train_schedule
    route_id = params[:id]
    @line = Transportation.find_by(route_id: route_id)

    @stations = TrainStop.where(route_id => "t").order("STATION_NAME")
  end

  def train_retrieve
    mapid = params[:mapid]
    url_safe_mapid = URI.encode(mapid)
    apiKey = "73b6a68e9e4f450792ba730b84d8c506"
    apiLink = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{apiKey}&mapid=#{url_safe_mapid}"
    apiResults = open(apiLink).read
    apiResults_JSON = Hash.from_xml(apiResults).to_json

    render :json => apiResults_JSON
  end

  def bus_schedule
    route_id = params[:id]
    @line = Transportation.find_by(route_id: route_id)
    apiKey = "UPGw2J5PBxNnF967CAMyHygeB"

    #First we retrieve the different directions of the line
    dirApiLink = "http://www.ctabustracker.com/bustime/api/v1/getdirections?key=#{apiKey}&rt=#{route_id}"
    dirApiResults = open(dirApiLink).read
    dirApiResults_Hash = Hash.from_xml(dirApiResults)

    #Then we retrieve the different stations for each direction
    i = 0
    @stations = {}
    dirApiResults_Hash["bustime_response"]["dir"].each do |dir|
      statApiLink = "http://www.ctabustracker.com/bustime/api/v1/getstops?key=#{apiKey}&rt=#{route_id}&dir=#{dir}"
      statApiResults = open(statApiLink).read
      statApiResults_Hash = Hash.from_xml(statApiResults)
      @stations[dir] = statApiResults_Hash
      i = i + 1
    end

  end

  def bus_retrieve
    stpid = params[:stpid]
    url_safe_stpid = URI.encode(stpid)
    apiKey = "UPGw2J5PBxNnF967CAMyHygeB"
    apiLink = "http://www.ctabustracker.com/bustime/api/v1/getpredictions?key=#{apiKey}&stpid=#{url_safe_stpid}"
    apiResults = open(apiLink).read
    apiResults_JSON = Hash.from_xml(apiResults).to_json

    render :json => apiResults_JSON
  end

  def directions
    @query = 0
  end

  def search_directions
    @query = 1
    @search_query = params[:search_stations]
    if @search_query.blank?
      @message = "No station found, try again"
    end

    render 'stations'
  end

end
