namespace :mailing_list do
  desc "add every user to the mailing list"
  task :add_all => :environment do
    users = User.all
    
    users.each do |user|
      begin
        puts "The mailing list is: #{ENV['MAILCHIMP_ML']}"
        puts "Adding #{user.login}"
        User.add_to_mailing_list(user.id)
      rescue
        puts "I cannot add user, login: #{user.login}, id: #{user.id}"
      end
    end
  end
end