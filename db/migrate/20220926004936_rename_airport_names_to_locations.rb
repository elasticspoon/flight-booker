class RenameAirportNamesToLocations < ActiveRecord::Migration[7.0]
  def change
    rename_column :airports, :name, :location
  end
end
