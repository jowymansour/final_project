require 'open-uri'

class CtaScheduleController < ApplicationController
  def new_search
    if logged_in?
      @favorites = current_user.favorites

      #Variables declaration
      predictions = {}
      @line_name = {}
      @text_of_predictions_bus = {}
      @text_of_predictions_train_5 = {}
      @text_of_predictions_train_1 = {}
      array_of_predictions = {}


      @favorites.each do |favorite|
        @text_of_predictions_bus[favorite.id] = ''
        @text_of_predictions_train_1[favorite.id] = ''
        @text_of_predictions_train_5[favorite.id] = ''

        # IF THE FAVORITE IS A BUS
        if favorite.type_transp == "bus"
          # We get back all the predictions for that particular favorite
          predictions[favorite.id] = bus_api(favorite.station_id)["bustime_response"]["prd"]

          #if there is no prediction for now
          if predictions[favorite.id].nil?
            @text_of_predictions_bus[favorite.id] = "There is actually no prediction for this Bus please try again later."

          else
            #If there is only 1 prediction for that favorite
            if !predictions[favorite.id][0]
              # We make an array out of the only result to avoid error when using .each
              array_of_predictions[favorite.id] = Array.new
              array_of_predictions[favorite.id][0] = predictions[favorite.id]

            #If there is >1
            else
              array_of_predictions[favorite.id] = predictions[favorite.id]
            end

            # If there is at least one prediction ==> We arrange the data
            array_of_predictions[favorite.id].each do |prediction|
              #Generate waiting time
              departure = prediction["tmstmp"]
              arrival = prediction["prdtm"]
              waiting_time = (Time.parse(arrival) - Time.parse(departure))/(60)
              @text_of_predictions_bus[favorite.id] = @text_of_predictions_bus[favorite.id] + '
                <h6 class="bus_results">
                  Bus #' +  prediction["vid"] + ' (to ' + prediction["des"] + ') -
                  <span class="time_result">' + waiting_time.to_i.to_s + ' minutes </span>
                </h6>
              '
            end

            #Set up of header text
            @line_name[favorite.id] = "Bus #" + array_of_predictions[favorite.id][0]["rt"] + " - " + array_of_predictions[favorite.id][0]["stpnm"] + " (" + array_of_predictions[favorite.id][0]["rtdir"] + ")"
          end

        # IF THE FAVORITE IS A TRAIN ---- TO DO
        elsif favorite.type_transp == "train"
          predictions[favorite.id] = train_api(favorite.station_id)["ctatt"]["eta"]

          #if there is no prediction for now
          if predictions[favorite.id].nil?
            @text_of_predictions_bus[favorite.id] = "There is actually no prediction for this train please try again later."

          else
            #If there is only 1 prediction for that favorite
            if !predictions[favorite.id][0]
              # We make an array out of the only result to avoid error when using .each
              array_of_predictions[favorite.id] = Array.new
              array_of_predictions[favorite.id][0] = predictions[favorite.id]

            #If there is >1
            else
              array_of_predictions[favorite.id] = predictions[favorite.id]
            end

            #If there is at least one prediction ==> We arrange the data
            array_of_predictions[favorite.id].each do |prediction|
             #Generate waiting time
              departure = prediction["prdt"]
              arrival = prediction["arrT"]
              waiting_time = (Time.parse(arrival) - Time.parse(departure))/(60)
              if prediction["trDr"] == "1"
                @direction_1 = prediction["stpDe"]
                @text_of_predictions_train_1[favorite.id] = @text_of_predictions_train_1[favorite.id] + '
                  <h6 class="train_results">train #' + prediction["rn"] + ' - <span class="time_result">' + waiting_time.to_i.to_s + ' minutes</span></h6>'
              elsif prediction["trDr"] == "5"
                @direction_5 = prediction["stpDe"]
                @text_of_predictions_train_5[favorite.id] = @text_of_predictions_train_5[favorite.id] + '
                  <h6 class="train_results">train #' + prediction["rn"] + ' - <span class="time_result">' + waiting_time.to_i.to_s + ' minutes</span></h6>'
              end
            end

            #Set up of header text
            line = Transportation.find_by(route_id: array_of_predictions[favorite.id][0]["rt"])
            @line_name[favorite.id] = line.route_long_name
            @line_name[favorite.id] = @line_name[favorite.id] + " - " + array_of_predictions[favorite.id][0]["staNm"]
          end
        end
      end
    end
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
    apiResults_JSON = train_api(mapid).to_json
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
    apiResults_JSON = bus_api(stpid).to_json

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


  private

  def train_api(mapid)
    url_safe_mapid = URI.encode(mapid)
    apiKey = "73b6a68e9e4f450792ba730b84d8c506"
    apiLink = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{apiKey}&mapid=#{url_safe_mapid}"
    apiResults = open(apiLink).read
    return Hash.from_xml(apiResults)
  end

  def bus_api(stpid)
    url_safe_stpid = URI.encode(stpid)
    apiKey = "UPGw2J5PBxNnF967CAMyHygeB"
    apiLink = "http://www.ctabustracker.com/bustime/api/v1/getpredictions?key=#{apiKey}&stpid=#{url_safe_stpid}"
    apiResults = open(apiLink).read
    return Hash.from_xml(apiResults)
  end
end
