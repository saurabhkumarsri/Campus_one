class CreateRouteStops < ActiveRecord::Migration[8.1]
  def change
    create_table :route_stops do |t|
      t.references :route, null: false
      t.string :stop_name, null: false
      t.integer :stop_order, null: false, default: 1
      t.time :morning_arrival_time
      t.time :evening_arrival_time
      t.timestamps
    end
  end
end
