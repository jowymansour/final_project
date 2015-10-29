class DropColumnTrainStops < ActiveRecord::Migration
  def change
    remove_column :train_stops, :DIRECTION_NUM
  end
end
