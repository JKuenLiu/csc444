class AddLatitudeAndLongitudeToPeople < ActiveRecord::Migration[5.2]
  def change
      add_column :people, :latitude, :float
      add_column :people, :longitude, :float
  end
end
