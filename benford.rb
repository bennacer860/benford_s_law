require 'benchmark'
require 'colored'

class Benford

	def initialize()
    	@data = randomize_data_set(22320)	
    	# puts @data 	
    	hash=compute_first_digit_frequency(@data)
    	draw_percentage(hash)
	end	

	#return an integer array 
	def randomize_data_set(max)
		(1...max).to_a #.sample(max/2)
	end

	#return a hash with the frequency of the first digit in the dataset
	def compute_first_digit_frequency(data)
		dataset_size = data.size 
		frequency    = Hash.new
		# puts data
		data.each do |el|
			el = el.to_s
			first_digit = el[0] 
			# puts first_digit
		    if frequency[first_digit]
				frequency[first_digit] += 1
			else
				frequency[first_digit] = 1
			end  
		end	
		
		frequency.each do |k,v|
			frequency[k]=(100.0*v/dataset_size).round(2)
		end

		#sort
		Hash[frequency.sort]
	end

	def draw_percentage(hash)
		puts hash
		hash.each { |k,v|
			s = '-' * v.round
			puts "#{k}: #{s}|"
		}
	end

	#compute the benford prediction based on his formula
	def compute_benford_prediction(n)
    	p=Math.log(1+(1.0/n),10) * 100
    	return p.round(2)
	end

	#compute the error margin
	def compute_error_margin(result,prediction)
		return  ((result.to_f-prediction.to_f)/prediction.to_f).abs*100
	end


end



time = Benchmark.measure do
	b=Benford.new	
	puts b.compute_error_margin(50,70) 
end
puts time*1000