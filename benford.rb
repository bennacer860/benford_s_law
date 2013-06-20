require 'benchmark'
require 'colored'
require 'csv'

class Benford

  def initialize(fname,attribute)
    # @data = randomize_data_set(12320,true)
    @data = load_file(fname,attribute)
    # puts @data
    hash=compute_first_digit_frequency(@data)
    if ARGV.include? 'log'
      draw_log_percentage(hash)
    else
      draw_percentage(hash)
    end
    load_file("data.csv","Population")
  end


  #return an integer array
  def randomize_data_set(max,sample=false)
    if sample
      (1...max).to_a.sample(max/2)
    else
      (1...max).to_a
    end
  end

  #load data from csv file
  def load_file(fname,attribute)
    csv_text = File.read(fname)
    data = Array.new()
    CSV.parse(csv_text, :headers => true) do |row|
      data << row[attribute]
    end
    return data
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
      benford_prediction = compute_benford_prediction(k.to_i)
      error_margin = compute_error_margin(v,benford_prediction)
      print "#{k}: #{s}|"
      print "result:#{v.round(2)}%"
      print "-error:#{error_margin.round(2)}%".red
      puts ""
    }
  end

  def draw_log_percentage(hash)
    puts hash
    hash.each { |k,v|
      logv = Math.log2(v)
      display_multiplier = 10
      s = '-' * (display_multiplier * logv).round
      benford_prediction = compute_benford_prediction(k.to_i)
      error_margin = compute_error_margin(v,benford_prediction)
      print "#{k}: #{s}|"
      print "result:#{logv.round(2)} (#{v.round(2)}%)."
      # print "-prediction:#{benford_prediction.round(2)}"
      print "-error:#{error_margin.round(2)}%".red
      puts ""
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
  b=Benford.new("data.csv","Population")
end
puts time*1000
