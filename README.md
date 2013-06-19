Benford's Law
=============
I have been fascinated by Benford for a while, so i finally decided to create a small ruby script that will take a 
CSV file and compute the frequency distribution of the first digit.
The interesting part is that i haven't used any external library to draw the bar chart, i do everything in the terminal.
If you think that these charts woudl lack of accuracy you will be totally right. I am trying to compensate for this lack
of accuracy by computing the margin of error between the result obtained from the data set and Benford's predictions.
