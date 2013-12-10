require 'csv'


ARGV.each do |a|
	puts "Argument :#{a}"
end

#initialization
num_of_clusters = 1
radius = 0
centroids = Array.new
centroid_of_point = Array.new




def euclidean_distance(p1,p2)
	#puts "Distance between #{p1} and #{p2}"
	sum_of_squares = 0
	p1.each_with_index do |p1_coord,index| 
		unless p1_coord.kind_of?(String)
			sum_of_squares += (p1_coord - p2[index]) ** 2 
		end
	end
	return Math.sqrt( sum_of_squares )
end

# def find_the_most_distant_point(centroids, points)
# 	first_centroid = centroids[0]
# 	puts first_centroid
# 	max = 0
# 	fartest_index = 0
# 	points.each_with_index do |centroid,index|
# 		distance = euclidean_distance(first_centroid, points[index])
# 		#puts "distance is #{distance}"
# 		unless max > distance
# 			max = distance
# 			fartest_index=index
# 		end
# 	end
# 	#puts "max distance is #{max}, which is #{points[fartest_index]}"
# 	return points[fartest_index]
# end

def find_the_next_most_distant_point(centroids, points)
	max = 0
	fartest_index = 0
	centroids.each_with_index do |centroid, index|
		points.each_with_index do |point,index|
			distance = euclidean_distance(centroid, points[index])
			#puts "distance is #{distance}"
			unless max > distance
				max = distance
				fartest_index=index
			end
		end
	end
	#puts "max distance is #{max}, which is #{points[fartest_index]}"
	return points[fartest_index]
end

#distribute every points to nearest centroids.
def clustering(centroids, points, centroid_of_point)
	points.each_with_index do |point, point_index|
		min = 10000000000000000.0
		nearest_index = 0
		centroids.each_with_index do |centroid, centroid_index|
			distance = euclidean_distance(point,centroid)
			puts "centroid index is #{centroid_index}, distance is #{distance}"
			unless (distance>min) || (point.eql? centroid)
				min = distance
				nearest_index = centroid_index
				centroid_of_point[point_index] = centroid
				#puts "two arrays are equal."
			end
		end
		puts "#{point} belongs to centroid #{centroid_of_point[point_index]}, centroid:#{nearest_index}"
	end
	return centroid_of_point
end

def calculate_radius(centroids)
	sum = 0.0
	count = 0
	centroids.each do |centroid1|
		centroids.each do |centroid2|
			sum += euclidean_distance(centroid1,centroid2)/2
			count +=1
		end
	end
	result = sum/2
	puts "\ndistance of centroids is #{result}"
	return result
end

def calculate_distance_between_centroid(points, centroid_of_point, radius)
	points.each_with_index do |point, point_index|
		distance = euclidean_distance(point, centroid_of_point[point_index])
		unless radius > distance
			return true
		end
	end
	return false
end


#import dataset then convert into array
data = CSV.read(ARGV[0], :converters => :all)

#random select first centroid
centroids.push data[rand(data.length)]
puts "First centroid: #{centroids}"

#push second centroid to the centroid array
centroids.push find_the_next_most_distant_point(centroids,data)
puts centroids

#clustering assign each non-centroid point to a centroid
centroid_of_point = clustering(centroids, data, centroid_of_point)

#calculate raduis
radius = calculate_radius(centroids)
puts "Radius : #{radius}"

#check the distance between its centroids
while calculate_distance_between_centroid(data,centroid_of_point, radius) do
	num_of_clusters += 1
	radius = calculate_radius(centroids)
	
	centroids.push find_the_next_most_distant_point(centroids, data)
	centroid_of_point =  clustering(centroids, data, centroid_of_point)
	#puts centroids
	puts "Radius : #{radius}"
	puts "\nneed to find next centroid or not : true, number of centroids: #{num_of_clusters}"
end

puts "end of kmeans of clustering"
#if distance between its centroids > R, then add another centroids




