class UpdateTransportationColumns < ActiveRecord::Migration
  def change
    add_column :transportations, :route_id, :integer
    add_column :transportations, :route_short_name,:string
    add_column :transportations, :route_long_name,:string
    add_column :transportations, :route_type,:integer
    add_column :transportations, :route_url,:string
    add_column :transportations, :route_color,:string
    add_column :transportations, :route_text_color,:string
    remove_column :transportations, :type_transport
    remove_column :transportations, :route
    add_index :transportations, :route_id
  end
end
