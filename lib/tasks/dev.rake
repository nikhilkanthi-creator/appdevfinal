desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do

# Create sample users

   names = ["Ben", "Raghu", "Jelani"]

 3.times do |count|
    user = User.new
    user.username = names.at(count)
    user.email = ""
    user.encrypted_password = "password"
    user.created_at = Time.now
    user.updated_at = Time.now
    user.save
 end
 
 # create sample conversations
 10.times do | conversation |
   conversation = Conversation.new
   conversation.user_id = rand(1..3)
end
 # write out what we created

 p "Added #{User.count} Users"
 p "Added #{conversation_count} Conversations"
end
