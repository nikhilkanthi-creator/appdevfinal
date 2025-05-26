class ConversationsController < ApplicationController
  def index
    matching_conversations = Conversation.all

    @list_of_conversations = matching_conversations.order({ :created_at => :desc })

    render({ :template => "conversations/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_conversations = Conversation.where({ :id => the_id })

    @the_conversation = matching_conversations.at(0)

    render({ :template => "conversations/show" })
  end

  def create
    the_conversation = Conversation.new
    the_conversation.user_id = current_user.id

    if the_conversation.valid?
      the_conversation.save
      redirect_to("/conversations/#{the_conversation.id}", { :notice => "Conversation created successfully." })
    else
      redirect_to("/conversations", { :alert => the_conversation.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_conversation = Conversation.where({ :id => the_id }).at(0)

    the_conversation.user_id = params.fetch("query_user_id")

    if the_conversation.valid?
      the_conversation.save
      redirect_to("/conversations/#{the_conversation.id}", { :notice => "Conversation updated successfully."} )
    else
      redirect_to("/conversations/#{the_conversation.id}", { :alert => the_conversation.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_conversation = Conversation.where({ :id => the_id }).at(0)

    the_conversation.destroy

    redirect_to("/conversations", { :notice => "Conversation deleted successfully."} )
  end
end
