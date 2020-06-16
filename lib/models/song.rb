class Song < ActiveRecord::Base
    has_many :favorites 
    has_many :users, through: :favorites

    attr_accessor :prompt

    def menu
        
    end

    def sing_song          
        lyrics_array = self.lyrics.split(/\n+/)
        for i in 0...lyrics_array.length
            puts lyrics_array[i]
            sleep 2
        end
        puts "=========YOU SOUND GREAT!========="
    end

    def favorite
        Favorite.create(user)
    end

    def self.search
        puts "Please enter the artist of the song you would like to sing:"
        artist = gets.chomp
        puts "Please enter the title of the song you would like to sing:"
        title = gets.chomp
        # new_song = Song.create(artist: artist, title: title)
        new_song = Song.find_lyrics(artist, title)
        new_song
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
            Song.create(artist: artist, title: title, lyrics: lyrics_array)
        end
    end
end 