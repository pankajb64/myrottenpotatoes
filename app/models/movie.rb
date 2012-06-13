class Movie < ActiveRecord::Base

	def self.ratings
		select("DISTINCT rating").map(&:rating)
	end
end
