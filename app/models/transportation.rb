class Transportation < ActiveRecord::Base

  #The transportation table is added directly via CTA DATA .CSV files via a rake task

  #If we delete the transportation, we delete the favorites attached
  has_many :favorites, dependent: :destroy
end
