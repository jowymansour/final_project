module DirectionsHelper
# Some methods to help us figure out if the current stations is a favorite or not (train and bus)

  def stepIcons(step)
    case step.travel_mode
      when "WALKING"
        return image_tag("directions/walk.png", class: "direction-icon")
      when "TRANSIT"
        if step.transit_details.line.vehicle.name == "Bus"
          return image_tag "directions/bus.png", class: "direction-icon" + step.transit_details.line.short_name
        else
          return image_tag "directions/subway.png", class: "direction-icon" + step.transit_details.line.name
        end
    end
  end
end
