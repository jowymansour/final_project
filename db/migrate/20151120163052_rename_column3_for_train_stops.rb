class RenameColumn3ForTrainStops < ActiveRecord::Migration
  def change
    rename_column :train_stops, :Pnk, :Pink
  end
end
