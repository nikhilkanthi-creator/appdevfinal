Rails.application.routes.draw do
  # Routes for the Conversation resource:

  get("/", { :controller => "conversations", :action => "index"})
  
  # CREATE

  post("/insert_conversation", { :controller => "conversations", :action => "create" })
          
  # READ
  
  get("/conversations/:path_id", { :controller => "conversations", :action => "show" })
  
  # UPDATE
  
  post("/modify_conversation/:path_id", { :controller => "conversations", :action => "update" })
  
  # DELETE
  get("/delete_conversation/:path_id", { :controller => "conversations", :action => "destroy" })

  #------------------------------

  # Routes for the Message resource:

  # CREATE
  post("/insert_message", { :controller => "messages", :action => "create" })
            
  # DELETE
  get("/delete_message/:path_id", { :controller => "messages", :action => "destroy" })

  #------------------------------

  # Routes for the Spending habit input resource:

  # CREATE
  post("/insert_spending_habit_input", { :controller => "spending_habit_inputs", :action => "create" })
  
  # DELETE
  get("/delete_spending_habit_input/:path_id", { :controller => "spending_habit_inputs", :action => "destroy" })

  #------------------------------

  devise_for :users

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  
end
