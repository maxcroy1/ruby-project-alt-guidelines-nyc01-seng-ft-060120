class Song < ActiveRecord::Base
    belongs_to :collection 
    has_many :users, through: :collection
end 