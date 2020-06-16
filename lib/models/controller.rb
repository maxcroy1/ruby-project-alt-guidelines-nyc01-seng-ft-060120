class Controller 
    attr_accessor :user, :prompt, :current_song #be able to read and write the person logged in

    def initialize
        @prompt = TTY::Prompt.new #every time we initialize controller, get a new prompt 
    end 

    def greeting #instance method 
        puts "Welcome to CLI Karaoke!" 
        choice = prompt.select("What would you like to do?", %w(Register Login Exit))
        if choice == "Register" #register a new user 
            system "clear"
            User.register #call the register method on the instance
        elsif choice == "Login"
            system "clear"
            User.login
        end
    end  

    def main_menu
        choice = prompt.select("What would you like to do, #{self.user.username}?") do |menu|
            menu.choice "Search For A Song", -> { self.search }
            menu.choice "See Your Collection", -> { self.user.collection }
            menu.choice "Have Some Fun", -> { self.funfunfun }
            menu.choice "Exit"
        end
    end

    def search
        @current_song = Song.search()
        self.song_menu
    end

    def song_menu
        prompt.select("What would you like to do with the song #{current_song.title} by #{current_song.artist}?") do |menu|
            menu.choice "Sing This Song", -> { self.sing_song }
            menu.choice "Favorite This Song", -> { self.favorite }
            menu.choice "Back to Main Menu", -> { self.main_menu }
        end
    end

    def sing_song
        current_song.sing_song
        self.song_menu
    end


end 