class MessagesController < ApplicationController
  def index
    matching_messages = Message.all

    @list_of_messages = matching_messages.order({ :created_at => :desc })

    render({ :template => "messages/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_messages = Message.where({ :id => the_id })

    @the_message = matching_messages.at(0)

    render({ :template => "messages/show" })
  end

  def create
    the_message = Message.new
    the_message.initial_spending_habits_input_id = params.fetch("query_initial_spending_habits_input_id")
    the_message.user_id = current_user.id
    the_message.body = params.fetch("query_body")
    the_message.role = "user"
    the_message.conversation_id = params.fetch("conversation_id")

    if the_message.valid?
      the_message.save
      redirect_to("/conversations/#{the_message.conversation_id}", { :notice => "Message created successfully." })
    else
      redirect_to("/", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.initial_spending_habits_input_id = params.fetch("query_initial_spending_habits_input_id")
    the_message.user_id = params.fetch("query_user_id")

    if the_message.valid?
      the_message.save
      redirect_to("/messages/#{the_message.id}", { :notice => "Message updated successfully."} )
    else
      redirect_to("/messages/#{the_message.id}", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.destroy

    redirect_to("/messages", { :notice => "Message deleted successfully."} )
  end
end
