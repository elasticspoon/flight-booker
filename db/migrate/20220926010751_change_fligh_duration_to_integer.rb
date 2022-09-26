class ChangeFlighDurationToInteger < ActiveRecord::Migration[7.0]
  def change
    remove_column :flights, :duration, :time
    add_column :flights, :duration, :integer
  end
end
