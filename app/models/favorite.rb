class Favorite < ActiveRecord::Base
  #Each user can have as many favorites as they want
  belongs_to :user

  #Each station and trains can have many favorites attached
  belongs_to :transportation, :foreign_key => :route_id
  belongs_to :train_stops, :primary_key => :MAP_ID , :foreign_key => :station_id
end
