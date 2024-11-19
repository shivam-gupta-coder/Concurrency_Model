import subprocess
import matplotlib.pyplot as plt
import random

# Function to run the C executable and return the running time
def get_running_time(executable, arr_size):
    # Run the C executable and capture the output
    result = subprocess.run([executable, str(arr_size)], capture_output=True, text=True)
    # Assuming the output is the running time in seconds
    time_ =float(result.stdout.strip())*1000
    print(time_)
    return time_

# Function to get average running time by running the algorithm 1 time
def average_running_time(executable, arr_size, runs=3):
    times = [get_running_time(executable, arr_size) for _ in range(runs)]
    return sum(times) / len(times)

# Input sizes
# input_sizes = [1000, 5000, 10000, 20000, 40000, 50000, 60000, 80000,100000]

# input_sizes = [ 1000000, 1500000, 2000000, 2500000, 3000000, 3500000, 4000000, 4500000, 
#                5000000, 5500000, 6000000, 6500000, 7000000, 7500000, 8000000, 
#                8500000, 9000000, 9500000, 10000000]

# input_sizes = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41]
# input_sizes = list(range(100,10001, 200))
input_sizes = list(range(1,41, 1))
input_sizes.sort()  # Sort input sizes for a smoother plot

running_times_algo_1 = []
running_times_algo_2 = []

# Collect average running times for Algorithm 1 and Algorithm 2
for size in input_sizes:
    average_time_algo_1 = average_running_time('./sorting_algo_count_get_time1', size)
    running_times_algo_1.append(average_time_algo_1)

for size in input_sizes:
    average_time_algo_2 = average_running_time('./sorting_algo_count_get_time2', size)
    running_times_algo_2.append(average_time_algo_2)

# Plotting both algorithms on the same graph
plt.figure(figsize=(10, 6))

# Plot Algorithm 1
plt.plot(input_sizes, running_times_algo_1, label="Parallel Count Sort", marker='o', color='b')

# Plot Algorithm 2
plt.plot(input_sizes, running_times_algo_2, label="Non Distributed Count Sort", marker='o', color='r')

# Set exact values on x-axis
plt.ticklabel_format(style='plain', axis='x')
plt.xticks(input_sizes, rotation=75)  # Rotate x-axis labels for better readability if needed

# Adding labels and title
plt.xlabel("Input Size (number of elements)")
plt.ylabel("Average Running Time (milliseconds)")
plt.title("Average Running Time Comparison of Parallel Count Sort and Non Distributed Count Sort")

# Display the legend
plt.legend()

# Save the plot as a .png file
plt.savefig("count_sort_running_times_comparison.png")

# Show the plot
plt.show()