class SpendingHabitInputsController < ApplicationController

  def create
    conversation_id = params.fetch("conversation_id")
    the_spending_habit_input = SpendingHabitInput.new
    the_spending_habit_input.created_by_id = current_user.id
    the_spending_habit_input.conversation_id = params.fetch("conversation_id")
    the_spending_habit_input.groceries = params.fetch("query_groceries")
    the_spending_habit_input.gasfuel = params.fetch("query_gasfuel")
    the_spending_habit_input.diningrestaurants = params.fetch("query_diningrestaurants")
    the_spending_habit_input.travel_flights_hotels_uber = params.fetch("query_travel_flights_hotels_uber")
    the_spending_habit_input.airline_loyalty = params.fetch("query_airline_loyalty")
    the_spending_habit_input.annual_fee_tolerance = params.fetch("query_annual_fee_tolerance")

    if the_spending_habit_input.valid?
      the_spending_habit_input.save

            # 1. Get the message history and spending history

      existing_messages = the_spending_habit_input.conversation.messages.order(:created_at)
      
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

     message_list.push({ "role" => "user", "content" => "I spend #{the_spending_habit_input.groceries} on groceries, #{the_spending_habit_input.gasfuel} on gas/fuel, #{the_spending_habit_input.diningrestaurants} on restaurants, #{the_spending_habit_input.travel_flights_hotels_uber} on travel. I have a loyalty towards #{the_spending_habit_input.airline_loyalty} airlines. My annual fee tolerance is #{the_spending_habit_input.annual_fee_tolerance}."})


      # 3. Now send the package to OpenAI:
    
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        "model" => "gpt-3.5-turbo",
        "messages" => message_list,
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
                  "description" => "Human‐readable explanation of the recommendatio, approximately 200 words long, referencing specific input categories that swayed this decision"
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
    latest_message.conversation_id = the_spending_habit_input.conversation_id
    latest_message.user_id         = current_user.id
    latest_message.role            = "assistant"
    latest_message.body            = formatted_output
    latest_message.save

      redirect_to("/conversations/#{conversation_id}", { :notice => "Spending habit input created successfully." })
    else
      redirect_to("/spending_habit_inputs", { :alert => the_spending_habit_input.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_spending_habit_input = SpendingHabitInput.where({ :id => the_id }).at(0)

    the_spending_habit_input.destroy

    redirect_to("/spending_habit_inputs", { :notice => "Spending habit input deleted successfully."} )
  end
end
