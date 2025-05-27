# == Schema Information
#
# Table name: conversations
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class Conversation < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  has_many :spending_habit_inputs,
          class_name:  "SpendingHabitInput",
          foreign_key: "conversation_id",
          dependent:   :destroy
  has_many :messages, dependent: :destroy

end
