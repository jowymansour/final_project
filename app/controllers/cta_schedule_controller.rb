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

end
