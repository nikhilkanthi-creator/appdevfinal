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

      # 1. Get the message history and spending history

      associated_spendinghabits = the_message.initial_spending_habits_input

      existing_messages = the_message.conversation.messages.order(:created_at)
      
      # 2. Break this whole list of messages into system, user, and assistant arrays

      message_list = []
      existing_messages.each do | a_message |
        if a_message.role == "system"
          message_list.push({ "role" => "system", "content" => a_message.body })
        elsif a_message.role == "user"
          message_list.push({ "role" => "user", "content" => a_message.body })
        else
          message_list.push({ "role" => "assistant", "content" => a_message.body })
        end
      end

      # 2.1 add the spending habits to the user message

     message_list.push({ "role" => "user", "content" => "I spend #{associated_spendinghabits.groceries} on groceries, #{associated_spendinghabits.gasfuel} on gas/fuel, #{associated_spendinghabits.diningrestaurants} on restaurants, #{associated_spendinghabits.travel_flights_hotels_uber} on travel. I have a loyalty towards #{associated_spendinghabits.airline_loyalty} airlines. My annual fee tolerance is #{associated_spendinghabits.annual_fee_tolerance}."})


      # 3. Now send the package to OpenAI:
    
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        "model" => "gpt-3.5-turbo",
        "messages" => message_list
      }  
    )

    latest_llm_content = response.fetch("choices").at(0).fetch("message").fetch("content")

    latest_message = Message.new
    latest_message.conversation_id = the_message.conversation_id
    latest_message.user_id = current_user.id
    latest_message.role = "assistant"
    latest_message.body = latest_llm_content
    latest_message.save


      redirect_to("/conversations/#{the_message.conversation_id}", { :notice => "Message created successfully." })
    else
      redirect_to("/", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.destroy

    redirect_to("/messages", { :notice => "Message deleted successfully."} )
  end
end
