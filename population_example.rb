require 'benchmark'
require './benford'

time = Benchmark.measure { Benford.new("population_example.csv","Population") }
puts "\nBenchmark: #{time * 1000}"
