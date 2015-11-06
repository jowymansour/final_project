class Change < ActiveRecord::Migration
  def change
    change_column :favorites, :station_id, :string
  end
end
