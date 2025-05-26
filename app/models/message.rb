# == Schema Information
#
# Table name: messages
#
#  id                               :bigint           not null, primary key
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  initial_spending_habits_input_id :integer
#  user_id                          :integer
#
class Message < ApplicationRecord

  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  belongs_to :initial_spending_habits_input, required: true, class_name: "SpendingHabitInput", foreign_key: "initial_spending_habits_input_id"
  
end
