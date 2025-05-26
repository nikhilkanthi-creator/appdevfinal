Rails.application.routes.draw do
  # Routes for the Conversation resource:

  get("/", { :controller => "conversations", :action => "index"})
  # CREATE
  post("/insert_conversation", { :controller => "conversations", :action => "create" })
          
  # READ
  get("/conversations", { :controller => "conversations", :action => "index" })
  
  get("/conversations/:path_id", { :controller => "conversations", :action => "show" })
  
  # UPDATE
  
  post("/modify_conversation/:path_id", { :controller => "conversations", :action => "update" })
  
  # DELETE
  get("/delete_conversation/:path_id", { :controller => "conversations", :action => "destroy" })

  #------------------------------

  # Routes for the Message resource:

  # CREATE
  post("/insert_message", { :controller => "messages", :action => "create" })
          
  # READ
  get("/messages", { :controller => "messages", :action => "index" })
  
  get("/messages/:path_id", { :controller => "messages", :action => "show" })
  
  # UPDATE
  
  post("/modify_message/:path_id", { :controller => "messages", :action => "update" })
  
  # DELETE
  get("/delete_message/:path_id", { :controller => "messages", :action => "destroy" })

  #------------------------------

  # Routes for the Spending habit input resource:

  # CREATE
  post("/insert_spending_habit_input", { :controller => "spending_habit_inputs", :action => "create" })
          
  # READ
  get("/spending_habit_inputs", { :controller => "spending_habit_inputs", :action => "index" })
  
  get("/spending_habit_inputs/:path_id", { :controller => "spending_habit_inputs", :action => "show" })
  
  # UPDATE
  
  post("/modify_spending_habit_input/:path_id", { :controller => "spending_habit_inputs", :action => "update" })
  
  # DELETE
  get("/delete_spending_habit_input/:path_id", { :controller => "spending_habit_inputs", :action => "destroy" })

  #------------------------------

  devise_for :users

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  
end
