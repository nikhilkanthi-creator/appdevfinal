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

      system_message = Message.new
      system_message.conversation_id = the_conversation.id
      system_message.role = "system"
      system_message.user_id = current_user.id
      system_message.body = "You are an assistant trying to help the user select a credit card. The user is interested in travel credit cards. Based on the input of the user's spending patterns in specific categories, like dining and travel, you will search the web and bring back the credit card that will maximize their travel benefits (maybe in terms of redeemable points, miles, etc) based on their credit card usage. Look for airline credit cards if they mention airline loyalty, otherwise check the major brands like Chase, Discover, Capital One, American Express, and others for up-to-date deals. Consider signup bonuses and factor those in, as well. Give them a first-year return, 3 year return (total), 5 year return (total), and 3 year return (per year) and 5 year return (per year)."
      system_message.save

      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { "role" => "system", "content" => system_message.body},
            { "role" => "user", "content" => ""}
          ],
          "functions" => [
          {
            "name"        => "card_roi_schema",
            "description" => "Returns the best credit card and ROI numbers based on spend",
            "parameters"  => {
              "type"       => "object",
              "properties" => {
                "recommended_card"   => {
                  "type"        => "string",
                  "description" => "Name of the recommended credit card"
                },
                "first_year_return"  => {
                  "type"        => "number",
                  "description" => "Return in dollars after year 1"
                },
                "total_return_3yr"   => {
                  "type"        => "number",
                  "description" => "Total return in dollars over 3 years"
                },
                "total_return_5yr"   => {
                  "type"        => "number",
                  "description" => "Total return in dollars over 5 years"
                },
                "per_year_return_3yr" => {
                  "type"        => "number",
                  "description" => "Average annual return over 3 years"
                },
                "per_year_return_5yr" => {
                  "type"        => "number",
                  "description" => "Average annual return over 5 years"
                },
                "free_text"           => {
                  "type"        => "string",
                  "description" => "Human‐readable explanation of the recommendation"
                }
              },
              "required" => [
                "recommended_card",
                "first_year_return",
                "total_return_3yr",
                "total_return_5yr",
                "per_year_return_3yr",
                "per_year_return_5yr",
                "free_text"
              ]
            }
          }
        ],
        "function_call" => { "name" => "card_roi_schema" }
        }
      )

      choice        = response.fetch("choices").at(0)
      func_call     = choice.fetch("message").fetch("function_call")
      parsed        = JSON.parse(func_call.fetch("arguments"))

      formatted_output = <<~OUTPUT
        Recommended Card: #{parsed.fetch("recommended_card")}
        First Year Return: $#{parsed.fetch("first_year_return")}
        Total Return (3yr): $#{parsed.fetch("total_return_3yr")}
        Total Return (5yr): $#{parsed.fetch("total_return_5yr")}
        Annualized Return (3yr): $#{parsed.fetch("per_year_return_3yr")}
        Annualized Return (5yr): $#{parsed.fetch("per_year_return_5yr")}

        Explanation:
        #{parsed.fetch("free_text")}
      OUTPUT

      latest_message = Message.new
      latest_message.conversation_id = the_conversation.id
      latest_message.user_id         = current_user.id
      latest_message.role            = "assistant"
      latest_message.body            = formatted_output
      latest_message.save
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
