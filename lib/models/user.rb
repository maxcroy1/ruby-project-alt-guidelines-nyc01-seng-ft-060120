class User < ActiveRecord::Base
    has_many :collections 
    has_many :songs, through: :collections

    def self.names #array of all usernames 
        User.all.map{|user| user.username} #iterate through all users to get username 
    end 

end 