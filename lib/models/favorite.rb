class Favorite < ActiveRecord::Base
    belongs_to :user
    belongs_to :song

    def self.unfavorite(user_id, song_id)
        Favorite.find_by(user_id: user_id, song_id: song_id).destroy
    end 
end 