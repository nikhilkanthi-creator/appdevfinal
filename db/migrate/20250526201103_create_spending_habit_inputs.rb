class CreateSpendingHabitInputs < ActiveRecord::Migration[7.1]
  def change
    create_table :spending_habit_inputs do |t|
      t.integer :created_by_id
      t.integer :groceries
      t.integer :gasfuel
      t.integer :diningrestaurants
      t.integer :travel_flights_hotels_uber
      t.string :airline_loyalty
      t.integer :annual_fee_tolerance

      t.timestamps
    end
  end
end
