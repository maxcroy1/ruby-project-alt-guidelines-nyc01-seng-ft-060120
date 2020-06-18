class Controller 
    attr_accessor :user, :prompt, :current_song #be able to read and write the person logged in

    def add_song_to_queue
        user.add_song_to_queue(current_song)
        sleep_n_clear
        self.song_menu
    end

    def add_favorite_to_queue
        user.add_song_to_queue(current_song)
        sleep_n_clear
        self.favorites_menu
    end

    def collection 
        favorites_list = Favorite.where(user_id: user.id).pluck(:song_id) #return all song instances saved associated with user id 
        favorite_ids = Song.select{|song| favorites_list.include?(song.id)}
        favorite_songs = favorite_ids.map {|song| "#{convert_for_user(song.title)} by #{convert_for_user(song.artist)}"}
        favorite_songs << "Exit"
        selection = prompt.select("Choose a song from your favorites below:", favorite_songs, filter: true)
        if selection == "Exit"
            self.main_menu
        else 
            converted_selection = selection.split(/ by /)
            @current_song = Song.find_by(title: convert_to_read(converted_selection[0]), artist: convert_to_read(converted_selection[1]))
            self.favorites_menu
        end
    end 

    def convert_for_user(string)
        string.titleize.sub(/_/, " ")
    end

    def convert_to_read(string)
        string.sub(/ /, "_")
    end

    def read_queue
        puts "Your queue is:"
        for i in 1..user.queue.length
            puts "#{i}. #{convert_for_user(user.queue[i - 1].title)} by #{convert_for_user(user.queue[i - 1].artist)}"
        end
        self.queue_menu
    end

    def favorite
        Favorite.create(user_id: user.id, song_id: current_song.id)
        puts "You've added this song to your Favorites."
        sleep_n_clear
        self.favorites_menu
    end

    def favorites_menu
        prompt.select("What would you like to do with the song #{convert_for_user(current_song.title)} by #{convert_for_user(current_song.artist)}?") do |menu|
            menu.choice "Sing This Song", -> { self.sing_song_favorite }
            menu.choice "Unfavorite This Song", -> { self.unfavorite }
            menu.choice "Add This Song To Your Queue", -> { self.add_favorite_to_queue }
            menu.choice "Back to Main Menu", -> { self.main_menu }
        end
    end

    def funfunfun
        instructors = ["Andrew", "Eric", "Tashawn", "Jeffrey"]
        puts "The lucky participant is..."
        sleep 8
        lucky_instructor = instructors[rand(instructors.length)]
        puts "#{lucky_instructor}!!!!!!!"
        sleep 3
        puts "And they will be singing...."
        sleep 3
        surprise_song = Song.find(rand(Song.count))
        puts "#{surprise_song.title.titleize.sub(/_/, " ")} by #{surprise_song.artist.titleize.sub(/_/, " ")}!!!!!!!"
        choice = prompt.yes?("Are you ready, #{lucky_instructor}?")
        if choice 
            puts "3..."
            sleep 1 
            puts "2..."
            sleep 1 
            puts "1..."
            sleep 1 
            puts "=====GET SINGIN====="
            surprise_song.sing_song
        else 
            puts "Too bad...."
            sleep 2
            puts "3..."
            sleep 1 
            puts "2..."
            sleep 1 
            puts "1..."
            sleep 1 
            puts "=====GET SINGIN====="
            surprise_song.sing_song
        end 
        self.main_menu
    end 

    def greeting #instance method 
        system "clear"
        puts "Welcome to CLI Karaoke!" 
        choice = prompt.select("What would you like to do?", %w(Register Login Exit))
        if choice == "Register" #register a new user 
            system "clear"
            User.register #call the register method on the instance
        elsif choice == "Login" #login in an old user
            system "clear"
            User.login
        end
    end  

    def initialize
        @prompt = TTY::Prompt.new #every time we initialize controller, get a new prompt 
    end 

    def is_favorite?
        favorites_list = Favorite.where(user_id: user.id).pluck(:song_id) #return all song instances saved associated with user id
        if favorites_list.include?(current_song.id)
            self.favorites_menu
        else
            self.song_menu
        end
    end

    def main_menu # Show options for features
        choice = prompt.select("What would you like to do, #{self.user.username}?") do |menu|
            menu.choice "Search For A Song", -> { self.search }
            menu.choice "See Your Favorites", -> { self.collection }
            menu.choice "Your Queue", -> { self.queue_menu }
            menu.choice "Have Some Fun", -> { self.funfunfun }
            menu.choice "Exit"
        end
    end

    def play_queue
        progression = 0
        for i in 0...user.queue.length
            puts "Next up is #{convert_for_user(current_song.title)} by #{convert_for_user(current_song.artist)}"
            sleep 2
            choice = prompt.select("Are you ready?") do |menu|
                menu.choice "Play Song"
                menu.choice "Skip Song"
                menu.choice "Exit to Main Menu"
            end
            if choice == "Play Song"
                puts "3..."
                sleep 1
                puts "2..."
                sleep 1
                puts "1..."
                sleep 1
                puts "========================"
                sleep 1
                current_song.sing_song
                progression += 1
                sleep 2
            elsif choice == "Skip Song"
                progression += 1
            else
                break
            end
        end
        user.queue.slice!(0, progression)
        system "clear"
        puts "Your Session Is Over"
        sleep_n_clear
        self.main_menu
    end

    def queue_menu
        if !user.queue || user.queue.length == 0
            puts "There are no songs in your queue"
            sleep_n_clear
            self.main_menu
        else
            choice = prompt.select("Would you like to...") do |menu|
                menu.choice "Play your Queue", -> { self.play_queue }
                menu.choice "See your Queue", -> { self.read_queue }
                menu.choice "Back to Main Menu", -> { self.main_menu }
            end
        end
    end

    def search #Calls on the Song class method "search" to query our API for a song. Send user to song menu or favorites menu after successful query
        system "clear"
        @current_song = Song.search()
        self.is_favorite?
    end

    def sing_song
        current_song.sing_song
        self.song_menu
    end

    def sing_song_favorite
        current_song.sing_song
        self.favorites_menu
    end

    def song_menu
        system "clear"
        prompt.select("What would you like to do with the song #{convert_for_user(current_song.title)} by #{convert_for_user(current_song.artist)}?") do |menu|
            menu.choice "Sing This Song", -> { self.sing_song }
            menu.choice "Favorite This Song", -> { self.favorite }
            menu.choice "Add This Song To Your Queue", -> { self.add_song_to_queue }
            menu.choice "Back to Main Menu", -> { self.main_menu }
        end
    end

    def unfavorite
        Favorite.unfavorite(user.id, current_song.id)
        puts "This song has been removed from your favorites."
        sleep_n_clear
        self.song_menu
    end 

    private
    def convert_for_user(string)
        string.titleize.gsub(/_/, " ")
    end

    def convert_to_read(string)
        string.downcase.gsub(/ /, "_")
    end

    def sleep_n_clear
        sleep 2
        system "clear"
    end

end 