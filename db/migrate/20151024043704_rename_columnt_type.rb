class RenameColumntType < ActiveRecord::Migration
  def change
    rename_column :transportations, :type, :type_transport
  end
end
