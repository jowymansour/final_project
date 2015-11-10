class Transportation < ActiveRecord::Base
  #If we delete the transportation, we delete the favorites attached
  has_many :favorites, dependent: :destroy
end
