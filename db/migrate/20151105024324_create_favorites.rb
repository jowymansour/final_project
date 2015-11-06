class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string :type_transp
      t.integer :station_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
