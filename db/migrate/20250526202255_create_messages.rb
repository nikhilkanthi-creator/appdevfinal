class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.integer :initial_spending_habits_input_id
      t.integer :user_id

      t.timestamps
    end
  end
end
