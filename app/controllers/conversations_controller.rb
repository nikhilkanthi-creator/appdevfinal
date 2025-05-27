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

      sys = Message.new
      sys.conversation_id = the_conversation.id
      sys.role = "system"
      sys.user_id = current_user.id
      sys.body = "You are an assistant trying to help the user select a credit card. The user is interested in travel credit cards. Based on the input of the user's spending patterns in specific categories, like dining and travel, you will search the web and bring back the credit card that will maximize their travel benefits (maybe in terms of redeemable points, miles, etc) based on their credit card usage. Look for airline credit cards if they mention airline loyalty, otherwise check the major brands like Chase, Discover, Capital One, American Express, and others for up-to-date deals. Consider signup bonuses and factor those in, as well. Give them a first-year return, 3 year return (total), 5 year return (total), and 3 year return (per year) and 5 year return (per year)."
      redirect_to("/conversations/#{the_conversation.id}", { :notice => "Conversation created successfully." })
      sys.save

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
