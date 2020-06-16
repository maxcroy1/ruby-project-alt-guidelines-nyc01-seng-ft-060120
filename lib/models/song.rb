class Song < ActiveRecord::Base
    belongs_to :collection 
    has_many :users, through: :collection

    attr_accessor :prompt

    def menu
        @prompt = TTY::Prompt.new
        prompt.select("What would you like to do with the song #{self.title} by #{self.artist}?") do |menu|
            menu.choice "Sing This Song", -> { self.sing_song }
            menu.choice "Save This Song To Your Collection", -> {  }
            menu.choice "Back to Main Menu", -> { Controller.main_menu }
        end
    end

    def sing_song          
        lyrics_array = self.lyrics.split(/\n+/)
        for i in 0...lyrics_array.length
            puts lyrics_array[i]
            sleep 2
        end
    end

    def self.search
        puts "Please enter the artist of the song you would like to sing:"
        artist = gets.chomp
        puts "Please enter the title of the song you would like to sing:"
        title = gets.chomp
        # new_song = Song.create(artist: artist, title: title)
        Song.find_lyrics(artist, title)
    end

    def self.find_lyrics(artist, title)
        url = "https://api.lyrics.ovh/v1/#{artist}/#{title}"
        begin
            lyrics = RestClient.get(url)
        rescue RestClient::ExceptionWithResponse
            puts "Sorry, that song wasn't found, please search again"
            sleep 2
            system "clear"
            Song.search
        else
            body = JSON.parse(lyrics)
            lyrics_array = body["lyrics"]
            new_song = Song.create(artist: artist, title: title, lyrics: lyrics_array)
            binding.pry
            new_song.menu
        end
    end
end 