class RenameColumn4ForTrainStops < ActiveRecord::Migration
  def change
    rename_column :train_stops, :RED, :Red
    rename_column :train_stops, :BLUE, :Blue
    rename_column :train_stops, :BRN, :Brn
  end
end
