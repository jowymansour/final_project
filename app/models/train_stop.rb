class TrainStop < ActiveRecord::Base

  #The train stop table is added directly via CTA DATA .CSV files via a rake task

  #If we delete the train-stop, we delete the favorites attached
  has_many :favorites, :primary_key => :MAP_ID , :foreign_key => :station_id, dependent: :destroy
end
