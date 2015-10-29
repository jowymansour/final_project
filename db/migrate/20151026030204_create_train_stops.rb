class CreateTrainStops < ActiveRecord::Migration
  def change
    create_table :train_stops do |t|
      t.integer :STOP_ID
      t.string :DIRECTION_ID
      t.integer :DIRECTION_NUM
      t.string :STOP_NAME
      t.string :STATION_NAME
      t.string :STATION_DESCRIPTIVE_NAME
      t.string :MAP_ID
      t.boolean :ADA
      t.boolean :RED
      t.boolean :BLUE
      t.boolean :G
      t.boolean :BRN
      t.boolean :P
      t.boolean :Pexp
      t.boolean :Y
      t.boolean :Pnk
      t.boolean :O
      t.string :LATITUDE
      t.string :LONGITUDE

      t.timestamps null: false
    end
  end
end
