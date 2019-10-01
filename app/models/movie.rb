class Movie < ActiveRecord::Base

def self.with_rating(arr)
    if arr!=nil
        return Movie.where(:rating =>arr.keys)    
    else
        return Movie.all
    end
        
end
    
def self.all_rating()
    val=Movie.all.distinct.pluck('rating')
    return val
end
end
