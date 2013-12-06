require 'csv'


ARGV.each do |a|
	puts "Argument :#{a}"
end

#initialization
num_of_clusters = 1
radius = 0




def euclidean_distance(p1,p2)
	puts "Distance between #{p1} and #{p2}"
	sum_of_squares = 0
	p1.each_with_index do |p1_coord,index| 
		unless p1_coord.kind_of?(String)
			sum_of_squares += (p1_coord - p2[index]) ** 2 
		end
	end
	puts Math.sqrt( sum_of_squares )
end


data = CSV.read(ARGV[0], :converters => :all)

puts data[2][1].class

puts euclidean_distance(data[2],data[3])

#random select centroid
puts centroid = data[rand(data.length)]