class CreateFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :flights do |t|
      t.string :arrival_airport, limit: 3
      t.string :departure_airport, limit: 3
      t.datetime :departure
      t.time :duration

      t.timestamps
    end
    add_index :flights, :arrival_airport
    add_index :flights, :departure_airport
  end
end
