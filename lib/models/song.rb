class Song < ActiveRecord::Base
    has_many :favorites 
    has_many :users, through: :favorites

    attr_accessor :prompt

    def sing_song
        sleep_n_clear        
        lyrics_array = self.lyrics.split(/\n+/)
        countdown
        for i in 0...lyrics_array.length
            puts lyrics_array[i]
            sleep 2
        end
        puts "========= YOU SOUND GREAT! =========="
        sleep 2
    end

    def self.find_lyrics(artist, title)
        url = "https://api.lyrics.ovh/v1/#{artist}/#{title}"
        begin
            lyrics = RestClient.get(url)
        rescue RestClient::ExceptionWithResponse
            puts "Sorry, that song wasn't found, please search again"
            sleep_n_clear
            Song.search
        else
            body = JSON.parse(lyrics)
            lyrics_array = body["lyrics"]
            Song.create(artist: artist, title: title, lyrics: lyrics_array)
        end
    end

    def self.search
        puts "Please enter the artist of the song you would like to sing:"
        artist = self.convert_for_save(gets.chomp)
        puts "Please enter the title of the song you would like to sing:"
        title = self.convert_for_save(gets.chomp)
        # new_song = Song.create(artist: artist, title: title)
        if Song.find_by(artist: artist, title: title)
            new_song = Song.find_by(artist: artist, title: title)
        else
            new_song = Song.find_lyrics(artist, title)
        end
        new_song
    end

    private
    def countdown
        puts "=============== READY ==============="
        sleep 2
        puts "================ SET ================"
        sleep 2
        puts "================ GO ================="
        sleep 2
    end

    def sleep_n_clear
        sleep 2
        system "clear"
    end

    def self.convert_for_save(string)
        string.downcase.gsub(/(?<foo>['"''<''>''#''%''{''}''|''^''-''['']''`'])/,"").gsub(/&/, 'and').gsub(/ /, '_')
    end

    def self.sleep_n_clear
        sleep 2
        system "clear"
    end

end 