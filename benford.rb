require 'ascii_charts' # Drawing charts
require 'colored'      # Adding color to terminal output
require 'csv'          # Parsing CSV

class Benford

  # Public: Returns a chart with the computed data
  def initialize(file_name, attribute)
    @args = ARGV
    @data = load_file(file_name, attribute)
    hash  = compute_first_digit_frequency(@data)
    @lms  = compute_the_least_mean_square(hash)
    @args.include?('--log') ? draw_percentage(hash,true) : draw_percentage(hash)
    draw_ascii_chart(hash) if @args.include?('--ascii_chart')
    @data
  end

  private

  # Private: Return an integer array
  def randomize_data_set(max, sample = false)
    sample ? (1...max).to_a.sample(max / 2) : (1...max).to_a
  end

  # Private: Load data from a CSV file
  def load_file(file_name, attribute)
    data = []
    CSV.parse(File.read(file_name), :headers => true) do |row|
      data << row[attribute]
    end
    data
  end

  # Private: Return a hash with the frequency of the first digit in the dataset
  def compute_first_digit_frequency(data)
    frequency = {}
    data.each do |element|
      element = element.to_s
      first_digit = element[0]
      if frequency[first_digit]
        frequency[first_digit] += 1
      else
        frequency[first_digit] = 1
      end
    end

    frequency.each do |key, value|
      frequency[key] = (100.0 * value / data.size).round(2)
    end
    Hash[frequency.sort]
  end

  # Private: Draws a percentage chart (using the ascii_charts gem)
  def draw_ascii_chart(hash)
    puts hash if @args.include?('--hash')
    array = []
    hash.each { |key, value| array << [key, value] }
    puts AsciiCharts::Cartesian.new(array).draw
    puts "\nThe least mean square for this dataset is #{@lms}".blue if @args.include?('--lms')
    puts '-' * 50
  end

  # Private: Draws a percentage graph (set log to true to draw Base 10 log)
  def draw_percentage(hash,log=false)
    puts hash if @args.include?('--hash')
    hash.each do |key, value|	
      if log	
        logv = Math.log2(value)
        display_multiplier = 10
        s = '-' * (display_multiplier * logv).round
      else
      	s = '-' * value.round
      end  
      benford_prediction = compute_benford_prediction(key.to_i)
      error_margin = compute_error_margin(value, benford_prediction)
      print "#{key}: #{s}|"
      log == true ? result = "result:#{logv.round(2)} (#{value.round(2)}%)." : result = "result:#{value.round(2)}%" 
      print result
      print " - error:#{error_margin.round(2)}%\n".red
    end
    puts "\nThe least mean square for this dataset is #{@lms}".blue if @args.include?('--lms')
    puts '-' * 50
  end

  # Private: Computes Benford's prediction using his formula
  def compute_benford_prediction(n)
    (Math.log(1 + (1.0 / n), 10) * 100).round(2)
  end

  # Private: Computes the error margin
  def compute_error_margin(result,prediction)
    ((result.to_f - prediction.to_f) / prediction.to_f).abs * 100
  end

  #Private: Compute the least mean square
  def compute_the_least_mean_square(hash)
    benford_prediction = {"1"=>30.1, "2"=>17.6, "3"=>12.5, "4"=>9.7, "5"=>7.9, "6"=>6.7, "7"=>5.8, "8"=>5.1, "9"=>4.6}  
    #LMS = sum( (data(i)-prediction(i))^2 )  / sum( data(i)^2 )
    numerator = 0
    denominator = 0
    hash.each do |key,value|
      numerator += (value-benford_prediction[key])**2    
      # puts benford_prediction[key]
      denominator += value**2  
    end  
    return (numerator/denominator).round(2)
  end
end
