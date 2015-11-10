module CtaScheduleHelper
# Some methods to help us figure out if the current stations is a favorite or not (train and bus)

  def train_favorite?(train_station)
    @train_favorite = current_user.favorites.find_by(station_id: train_station.MAP_ID)
    if @train_favorite
      render :text => 'added_favorite'
    end
  end

  def bus_favorite?(stop_id)
    @favorite = Favorite.where(station_id: stop_id)
    if @favorite.first
      render :text => 'added_favorite'
    end
  end
end
