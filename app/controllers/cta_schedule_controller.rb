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
    @North = 0
    @South = 0
    @East = 0
    @West = 0
  end
end
