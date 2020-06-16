class Controller 
    attr_accessor :user, :prompt #be able to read and write the person logged in

    def initialize
        @prompt = TTY::Prompt.new #every time we initialize controller, get a new prompt 
    end 

    def greeting #instance method 
        puts "Welcome to CLI Karaoke!" 
        choice = prompt.select("What would you like to do?", %w(Register Login Exit))
        if choice == "Register" #register a new user 
            self.register #call the register method on the instance
        elsif choice == "Login"
            self.login
        end
    end 

    def register
        puts "What is your name?" 
        user_name = gets.chomp #collect username
        if User.names.include? (user_name) #if name given is already in array of names 
            puts "Sorry, that name is taken." 
            sleep 2 #pause 
            system "clear"
            self.register #start over register method
        else #if username is new/unique
            User.create(username: user_name) #create new user and save to database
            puts "Let's get musical, #{user_name}!"
            sleep 2
            system "clear"
            self.main_menu
        end
    end 

    def login 
        puts "Enter your username"
        user_name = gets.chomp #collect username 
        if User.names.include? (user_name) #if name given is in array of names 
            puts "Let's get musical, #{user_name}!" #login
            sleep 2
            system "clear"
            self.main_menu
        else #if there is no user with that name 
            puts "That name is invalid."
            choice = prompt.yes?("Would you like to register a new account with that name?")
            if choice #if they select yes to registering a new account 
                User.create(username: user_name) #create new user and save to database
                puts "Let's get musical, #{user_name}!"
                sleep 2
                system "clear"
                self.main_menu
            else #if they select no to registering a new account
                self.login #go back to start of login 
            end
        end
    end 

    def main_menu
        choice = prompt.select("What would you like to do?") do |menu|
            menu.choice "Search For A Song", -> { self.search }
            menu.choice "See Your Collection", -> { self.collection }
            menu.choice "Have Some Fun", -> { self.funfunfun }
            menu.choice "Exit"
        end
    end

    def search
        puts "Please enter the artist of the song you would like to sing:"
        artist = gets.chomp
        puts "Please enter the title of the song you would like to sing:"
        title = gets.chomp
        new_song = Song.create(artist: artist, title: title)
        new_song.find_lyrics
        puts new_song.lyrics
    end

end 