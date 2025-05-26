class SpendingHabitInputsController < ApplicationController
  def index
    matching_spending_habit_inputs = SpendingHabitInput.all

    @list_of_spending_habit_inputs = matching_spending_habit_inputs.order({ :created_at => :desc })

    render({ :template => "spending_habit_inputs/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_spending_habit_inputs = SpendingHabitInput.where({ :id => the_id })

    @the_spending_habit_input = matching_spending_habit_inputs.at(0)

    render({ :template => "spending_habit_inputs/show" })
  end

  def create
    the_spending_habit_input = SpendingHabitInput.new
    the_spending_habit_input.created_by_id = params.fetch("query_created_by_id")
    the_spending_habit_input.groceries = params.fetch("query_groceries")
    the_spending_habit_input.gasfuel = params.fetch("query_gasfuel")
    the_spending_habit_input.diningrestaurants = params.fetch("query_diningrestaurants")
    the_spending_habit_input.travel_flights_hotels_uber = params.fetch("query_travel_flights_hotels_uber")
    the_spending_habit_input.airline_loyalty = params.fetch("query_airline_loyalty")
    the_spending_habit_input.annual_fee_tolerance = params.fetch("query_annual_fee_tolerance")

    if the_spending_habit_input.valid?
      the_spending_habit_input.save
      redirect_to("/spending_habit_inputs", { :notice => "Spending habit input created successfully." })
    else
      redirect_to("/spending_habit_inputs", { :alert => the_spending_habit_input.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_spending_habit_input = SpendingHabitInput.where({ :id => the_id }).at(0)

    the_spending_habit_input.created_by_id = params.fetch("query_created_by_id")
    the_spending_habit_input.groceries = params.fetch("query_groceries")
    the_spending_habit_input.gasfuel = params.fetch("query_gasfuel")
    the_spending_habit_input.diningrestaurants = params.fetch("query_diningrestaurants")
    the_spending_habit_input.travel_flights_hotels_uber = params.fetch("query_travel_flights_hotels_uber")
    the_spending_habit_input.airline_loyalty = params.fetch("query_airline_loyalty")
    the_spending_habit_input.annual_fee_tolerance = params.fetch("query_annual_fee_tolerance")

    if the_spending_habit_input.valid?
      the_spending_habit_input.save
      redirect_to("/spending_habit_inputs/#{the_spending_habit_input.id}", { :notice => "Spending habit input updated successfully."} )
    else
      redirect_to("/spending_habit_inputs/#{the_spending_habit_input.id}", { :alert => the_spending_habit_input.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_spending_habit_input = SpendingHabitInput.where({ :id => the_id }).at(0)

    the_spending_habit_input.destroy

    redirect_to("/spending_habit_inputs", { :notice => "Spending habit input deleted successfully."} )
  end
end
