class User < ActiveRecord::Base
    has_many :favorites
    has_many :songs, through: :favorites

    attr_accessor :prompt
    attr_reader :queue

    # Serves as user's session queue. Data is not meant to be persistent.
    def add_song_to_queue(song)
        if queue
            @queue << song
        else
            self.create_queue
            @queue << song
        end
        puts "#{convert_for_user(song.title)} by #{convert_for_user(song.artist)} has been added to your queue."
    end

    #Creates queue to store queue information if a queue does not exist for this session
    def create_queue
        @queue = []
    end

    def read_queue(session)
        puts "Your queue is:"
        for i in 1..self.queue.length
            puts "#{i}. #{convert_for_user(self.queue[i - 1].title)} by #{convert_for_user(self.queue[i - 1].artist)}"
        end
        session.queue_menu
    end

    def self.login 
        puts "Enter your username"
        user_name = gets.chomp #collect username 
        if User.names.include? (user_name) #if name given is in array of names 
            puts "Let's get musical, #{user_name}!" #login
            sleep_n_clear
            User.find_by(username: user_name) #returns user instance to be tracked by Controller
        else #if there is no user with that name 
            puts "That name is invalid."
            prompt = TTY::Prompt.new
            choice = prompt.yes?("Would you like to register a new account with that name?")
            if choice #if they select yes to registering a new account 
                puts "Let's get musical, #{user_name}!"
                sleep_n_clear
                User.create(username: user_name) #create new user and return user instance to be tracked by Controller
            else #if they select no to registering a new account
                User.login #go back to start of login 
            end
        end
    end

    def self.names #array of all usernames 
        User.all.map{|user| user.username} #iterate through all users to get username 
    end 

    def self.register
        puts "What is your name?" 
        user_name = gets.chomp #collect username
        if User.names.include? (user_name) #if name given is already in array of names 
            puts "Sorry, that name is taken." 
            sleep_n_clear
            User.register #start over register method
        else #if username is new/unique
            puts "Let's get musical, #{user_name}!"
            sleep_n_clear
            User.create(username: user_name) #create new user and save to database
        end
    end 

    private
    def convert_for_user(string)
        string.titleize.sub(/_/, " ")
    end

    def self.sleep_n_clear
        sleep 2 #pause 
        system "clear"
    end

end 