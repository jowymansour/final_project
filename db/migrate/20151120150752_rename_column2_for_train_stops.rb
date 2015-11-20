class RenameColumn2ForTrainStops < ActiveRecord::Migration
  def change
    rename_column :train_stops, :STATION_NAME, :station_name
  end
end
