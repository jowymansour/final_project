class AddRouteIdToFavorite < ActiveRecord::Migration
  def change
    add_column :favorites, :route_id, :string
  end
end
