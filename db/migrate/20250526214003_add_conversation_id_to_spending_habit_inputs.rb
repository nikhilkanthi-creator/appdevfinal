class AddConversationIdToSpendingHabitInputs < ActiveRecord::Migration[7.1]
  def change
    add_column :spending_habit_inputs, :conversation_id, :bigint
    add_index :spending_habit_inputs, :conversation_id
  end
end
