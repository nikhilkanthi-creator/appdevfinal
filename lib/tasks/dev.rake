desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do

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

 p "Added #{User.count} Users"

end
