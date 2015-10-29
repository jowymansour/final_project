class DropMoreColumnsTrainstops < ActiveRecord::Migration
  def change
    add_column :train_stops, :Location, :string
    remove_column :train_stops, :LATITUDE
    remove_column :train_stops, :LONGITUDE
  end
end
