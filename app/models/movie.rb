class Movie < ActiveRecord::Base

def self.with_rating(arr) #Function takes in array of ratings and returns filtered out values 
    if arr!=nil
        return Movie.where(:rating =>arr.keys)    
    else
        return Movie.all
    end
end
    
def self.all_rating() #returns the filter values 
    val=Movie.all.distinct.pluck('rating')
    return val
end
end
