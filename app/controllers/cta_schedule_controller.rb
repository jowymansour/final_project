class CtaScheduleController < ApplicationController
  def new_search
  end

  def transportation_request
    line_request = params[:line]
    lines =  Transportation.where("route like ?", "%#{line_request}%")

    render :json => lines
  end

end
