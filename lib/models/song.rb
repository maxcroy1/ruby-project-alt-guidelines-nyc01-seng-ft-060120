class Song < ActiveRecord::Base
    belongs_to :collection 
    has_many :users, through: :collection

    def find_lyrics
        url = "https://api.lyrics.ovh/v1/#{self.artist}/#{self.title}"
        self.lyrics = RestClient.get(url)
        self.save
    end

end 