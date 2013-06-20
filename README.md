# Benford's Law

I have been fascinated by Benford for a while, so I finally decided to create a small Ruby script that will take a CSV file and compute the frequency distribution of the first digit.

## Usage

An example of the use of this script can be found in the `population_example.rb` file. Note that to compensate for the lack of accuracy of this graph, the margin of error is computed between the result obtained from the dataset and Benford's predictions. When run, the output should look like this.

```
1: ---------------------------------------------------------|result:56.86% - error:88.9%
2: ---------------------|result:20.68% - error:17.43%
3: --------|result:8.15% - error:34.75%
4: -----|result:5.37% - error:44.58%
5: ---|result:2.98% - error:62.37%
6: --|result:2.19% - error:67.26%
7: -|result:0.99% - error:82.93%
8: -|result:1.19% - error:76.76%
9: --|result:1.59% - error:65.28%

Benchmark:  20.000000   0.000000  20.000000 ( 16.088452)
```

You can also pass it a `--log` option to display the data in a log graph. There is also the `--hash` option which displays the Hash generated to calculate the graph. Running `ruby population_example.rb --log --hash` would give us this.

```
{"1"=>56.86, "2"=>20.68, "3"=>8.15, "4"=>5.37, "5"=>2.98, "6"=>2.19, "7"=>0.99, "8"=>1.19, "9"=>1.59}
1: ----------------------------------------------------------|result:5.83 (56.86%). - error:88.9%
2: --------------------------------------------|result:4.37 (20.68%). - error:17.43%
3: ------------------------------|result:3.03 (8.15%). - error:34.75%
4: ------------------------|result:2.42 (5.37%). - error:44.58%
5: ----------------|result:1.58 (2.98%). - error:62.37%
6: -----------|result:1.13 (2.19%). - error:67.26%
7: |result:-0.01 (0.99%). - error:82.93%
8: ---|result:0.25 (1.19%). - error:76.76%
9: -------|result:0.67 (1.59%). - error:65.28%

Benchmark:  20.000000   0.000000  20.000000 ( 16.088452)
```

There is also a possibility of using the script with the `--ascii_chart` option (*without the other options, they will be ignored anyway*), whose result would look like this.

```
60.0|
55.0|*
50.0|
45.0|
40.0|
35.0|
30.0|
25.0|
20.0|  *
15.0|
10.0|    *
 5.0|      * *
 0.0+----------*-*-*-*-
     1 2 3 4 5 6 7 8 9

Benchmark:  20.000000   0.000000  20.000000 ( 16.563178)
```

### Dependencies

Overall, two external (non-standard-library) libraries are used. The first one being the [colored](https://rubygems.org/gems/colored) gem which allows us to add color to the output. The second is the [ascii_charts](https://rubygems.org/gems/ascii_charts) library which helped to plot the other chart (the one that is generated once the `--ascii_chart` option is passed in).

## Resources

- http://testingbenfordslaw.com/
- http://en.wikipedia.org/wiki/Benford's_law
- http://www.youtube.com/watch?v=XXjlR2OK1kM
- http://www.isaca.org/Journal/Past-Issues/2011/Volume-3/Pages/Understanding-and-Applying-Benfords-Law.aspx

# To Do
- Compute the mean absolute deviation to score the result
- Create a dataset with Fibonacci series and test it
