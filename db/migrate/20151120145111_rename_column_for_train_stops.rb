class RenameColumnForTrainStops < ActiveRecord::Migration
  def change
    rename_column :train_stops, :station_descriptive_name, :station_descriptive_name
  end
end
