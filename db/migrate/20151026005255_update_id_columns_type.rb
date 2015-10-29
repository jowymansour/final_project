class UpdateIdColumnsType < ActiveRecord::Migration
  def change
    change_column :transportations, :route_id, :string
  end
end
