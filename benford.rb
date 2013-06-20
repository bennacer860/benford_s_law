require 'ascii_charts' # Drawing charts
require 'colored'      # Adding color to terminal output
require 'csv'          # Parsing CSV

class Benford

  # Public: Returns a chart with the computed data
  def initialize(file_name, attribute)
    @args = ARGV
    @data = load_file(file_name, attribute)
    hash  = compute_first_digit_frequency(@data)
    if @args.include?('--ascii_chart')
      draw_ascii_chart(hash)
    else
      @args.include?('--log') ? draw_log_percentage(hash) : draw_percentage(hash)
    end
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
    array = []
    hash.each { |key, value| array << [key, value] }
    puts AsciiCharts::Cartesian.new(array).draw
  end

  # Private: Draws a percentage graph
  def draw_percentage(hash)
    puts hash if @args.include?('--hash')
    hash.each do |key, value|
      s = '-' * value.round
      benford_prediction = compute_benford_prediction(key.to_i)
      error_margin = compute_error_margin(value, benford_prediction)
      print "#{key}: #{s}|"
      print "result:#{value.round(2)}%"
      print " - error:#{error_margin.round(2)}%".red
      puts
    end
  end

  # Private: Draws a percentage log graph
  def draw_log_percentage(hash)
    puts hash if @args.include?('--hash')
    hash.each do |key, value|
      logv = Math.log2(value)
      display_multiplier = 10
      s = '-' * (display_multiplier * logv).round
      benford_prediction = compute_benford_prediction(key.to_i)
      error_margin = compute_error_margin(value, benford_prediction)
      print "#{key}: #{s}|"
      print "result:#{logv.round(2)} (#{value.round(2)}%)."
      print " - error:#{error_margin.round(2)}%".red
      puts
    end
  end

  # Private: Computes Benford's prediction using his formula
  def compute_benford_prediction(n)
    p = Math.log(1 + (1.0 / n), 10) * 100
    p.round(2)
  end

  # Private: Computes the error margin
  def compute_error_margin(result,prediction)
    ((result.to_f - prediction.to_f) / prediction.to_f).abs * 100
  end
end
