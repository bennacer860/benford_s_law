require 'benchmark'
require './benford'

time = Benchmark.measure { Benford.new("data/population_example.csv","Population") }
puts "\nBenchmark: #{time * 1000}"
