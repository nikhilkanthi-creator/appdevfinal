# == Schema Information
#
# Table name: spending_habit_inputs
#
#  id                         :bigint           not null, primary key
#  airline_loyalty            :string
#  annual_fee_tolerance       :integer
#  diningrestaurants          :integer
#  gasfuel                    :integer
#  groceries                  :integer
#  travel_flights_hotels_uber :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  conversation_id            :bigint
#  created_by_id              :integer
#
# Indexes
#
#  index_spending_habit_inputs_on_conversation_id  (conversation_id)
#
class SpendingHabitInput < ApplicationRecord

  validates :created_by_id, presence: true
  belongs_to :created_by, required: true, class_name: "User", foreign_key: "created_by_id"
  has_many  :messages, class_name: "Message", foreign_key: "initial_spending_habits_input_id", dependent: :destroy
  belongs_to :conversation, required:   true, class_name: "Conversation",foreign_key:"conversation_id"
end
