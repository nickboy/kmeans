require 'csv'


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
			unless centroids.include? point
				distance = euclidean_distance(centroid, points[index])

				unless max > distance
					max = distance
					fartest_index=index
				end
			end
		end
	end
	#puts "max distance is #{max}, which is #{points[fartest_index]}"
	return points[fartest_index]
end


# def find_the_next_most_distant_point(centroids, points)
# 	max = 0
# 	fartest_index = 0
# 	distance_between_centroids = Array.new

# 	points.each_with_index do |point,index|
		
# 		unless centroids.include? point
# 			centroids.each_with_index do |centroid, index|
# 				distance_between_centroids.push euclidean_distance(centroid, point)
# 			end
# 			puts point
# 			puts "distance between centroids: #{distance_between_centroids}"
# 			puts distance_between_centroids.min
# 			min_distance_between_centroids = distance_between_centroids.min

# 			if min_distance_between_centroids > max
# 				fartest_index = index
# 				max = min_distance_between_centroids
# 			end
# 		end
# 		distance_between_centroids.clear
# 	end


# 	return points[fartest_index]
# end

#distribute every points to nearest centroids.
def clustering(centroids, points, centroid_of_point)
	points.each_with_index do |point, point_index|
		min = 10000000000000000.0
		nearest_index = 0
		centroids.each_with_index do |centroid, centroid_index|
			distance = euclidean_distance(point,centroid)
			#puts "centroid index is #{centroid_index}, distance is #{distance}"
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
	count = 0
	points.each_with_index do |point, point_index|
		distance = euclidean_distance(point, centroid_of_point[point_index])
		unless radius > distance
			count +=1
		end
	end
	if (count > 10)
		return true
	else
		return false
	end
end

def relocate_centroids(centroids, points,centroids_points)
	puts centroids_points.uniq
	average_distance = 0.0
	new_centroids = centroids

	centroids.each_with_index do |centroid, index|
		points_index_belong_to_centroid = centroids_points.each_index.select{|i| centroids_points[i] == centroid}
		puts "points belong to #{centroid} are #{points_index_belong_to_centroid}"
		old_centroid = centroid
		new_centroid_id = 0
		new_centroid_average_distance = 100000000000.0
		

		points_index_belong_to_centroid.each do |main_point_index|
			count = 0
			sum = 0.0
			
			#calculate average distance for main_point_index
			points_index_belong_to_centroid.each do |point_index|
				count += 1
				sum += euclidean_distance(points[main_point_index],points[point_index])
			end
			average = sum / count
			#puts "Mainpoints is #{points[main_point_index]}, average is #{average}"
			#relocate the centroid if average distance to points is shorter than current centroid
			if (average)< new_centroid_average_distance
				
				#updatethe centroid array
				new_centroid_id = main_point_index
				new_centroid_average_distance = average

				new_centroids.map!{ |x| x ==  old_centroid ? points[new_centroid_id] : x }
				#puts "new centroid list : #{new_centroids}"

				#puts "Nickboy move centroid #{old_centroid} to #{points[new_centroid_id]}, average is #{average}, new centroid list : #{new_centroids}"
				old_centroid = points[main_point_index]
			end
		end
		
		
		#changed points' centroid to new centroid.
		points_index_belong_to_centroid.each do |point_index|
			#puts "Nickboy original centroids #{centroids}"
			centroids.each_with_index do |element, index|
  				centroids[index] = points[new_centroid_id] if element == centroids_points[point_index] # or x[index].replace("hi") if element == "hello"
			end
			centroids_points[point_index] = points[new_centroid_id]
			#puts "Nickboy move #{centroids_points[point_index]} to #{points[new_centroid_id]}"
			#puts "Nickboy #{centroids}"
		end
	end

	return centroids_points, new_centroids
end

def compute_result(data, centroid_list)
	number_of_data = data.count
	number_of_wrong = 0
	number_of_correct = 0

	data.each_with_index do |point, index|
		# puts "POINT : #{point[4]}"
		# puts "Centroid : #{centroid_list[index][4]}"
		if point[4] == centroid_list[index][4]

			number_of_correct +=1
		else
			number_of_wrong +=1
		end
	end
	result = number_of_correct.to_f / number_of_data
	puts "Number of Correct : #{number_of_correct}"
	puts "Accuracy : #{result}"
end


if __FILE__ == $0
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

	#reposition centroid
	puts "old centroids : #{centroids}"
	result = relocate_centroids(centroids, data, centroid_of_point)
	puts "new centroids : #{result[1]}"
	centroids = result[1]
	centroid_of_point = result[0]

	#calculate raduis
	radius = calculate_radius(centroids)
	puts "Radius : #{radius}"

	#check the distance between its centroids
	while calculate_distance_between_centroid(data,centroid_of_point, radius) do
		
		radius = calculate_radius(centroids)
		

		centroids.push find_the_next_most_distant_point(centroids, data)
		centroid_of_point =  clustering(centroids, data, centroid_of_point)

		# puts "old centroids : #{centroids}"
		# result = relocate_centroids(centroids, data, centroid_of_point)
		# puts "new centroids : #{result[1]}"
		# centroids.empty
		# centroids = result[1]
		# centroid_of_point = result[0]


		#puts centroids
		puts "Radius : #{radius}"
		puts "\nneed to find next centroid or not : true"
	end



	points_summary = Hash.new(0)
	centroid_of_point.each { | point | points_summary.store(point, points_summary[point]+1) }
	puts "points_location_summary : #{points_summary}"

	#centroid_of_point.each { | point | puts "#{point}" }

	puts "end of kmeans of clustering, number of centroids: #{centroids.count}"
	puts "\n#{centroids}"

	compute_result(data,centroid_of_point)



	#if distance between its centroids > R, tpoint_summaryen add another centroids
end
