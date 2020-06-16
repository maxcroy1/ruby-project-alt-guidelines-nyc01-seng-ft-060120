class User < ActiveRecord::Base
    has_many :favorites
    has_many :songs, through: :favorites

    def self.register
        puts "What is your name?" 
        user_name = gets.chomp #collect username
        if User.names.include? (user_name) #if name given is already in array of names 
            puts "Sorry, that name is taken." 
            sleep 2 #pause 
            system "clear"
            User.register #start over register method
        else #if username is new/unique
            puts "Let's get musical, #{user_name}!"
            sleep 2
            system "clear"
            User.create(username: user_name) #create new user and save to database
        end
    end 

    def self.login 
        puts "Enter your username"
        user_name = gets.chomp #collect username 
        if User.names.include? (user_name) #if name given is in array of names 
            puts "Let's get musical, #{user_name}!" #login
            sleep 2
            system "clear"
            @user = User.find_by(username: user_name)
        else #if there is no user with that name 
            puts "That name is invalid."
            choice = prompt.yes?("Would you like to register a new account with that name?")
            if choice #if they select yes to registering a new account 
                puts "Let's get musical, #{user_name}!"
                sleep 2
                system "clear"
                @user = User.create(username: user_name) #create new user and save to database
            else #if they select no to registering a new account
                User.login #go back to start of login 
            end
        end
    end

    def self.names #array of all usernames 
        User.all.map{|user| user.username} #iterate through all users to get username 
    end 

end 