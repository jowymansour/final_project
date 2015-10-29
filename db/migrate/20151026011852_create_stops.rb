class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.integer :stop_id
      t.integer :stop_code
      t.string :stop_name
      t.string :stop_desc
      t.string :stop_lat
      t.string :stop_lon
      t.integer :location_type
      t.integer :parent_station
      t.integer :wheelchair_boarding

      t.timestamps null: false
    end
    add_index :stops, :stop_id
  end
end
