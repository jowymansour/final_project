class CreateTransportations < ActiveRecord::Migration
  def change
    create_table :transportations do |t|
      t.string :type
      t.string :route
      t.timestamps null: false
    end
  end
end
