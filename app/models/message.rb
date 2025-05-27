# == Schema Information
#
# Table name: messages
#
#  id                               :bigint           not null, primary key
#  body                             :text
#  role                             :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  conversation_id                  :bigint           not null
#  initial_spending_habits_input_id :integer
#  user_id                          :integer
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#
# Foreign Keys
#
#  fk_rails_...  (conversation_id => conversations.id)
#
class Message < ApplicationRecord

  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  belongs_to :initial_spending_habits_input, optional: true, class_name: "SpendingHabitInput", foreign_key: "initial_spending_habits_input_id"
  belongs_to :conversation, required: true, class_name: "Conversation", foreign_key: "conversation_id"
end
