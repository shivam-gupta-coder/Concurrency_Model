import subprocess
import matplotlib.pyplot as plt
import numpy as np

# Function to run the measure.sh script with the given executable and return the memory usage
def get_memory_usage(executable, arr_size):
    try:
        # Run measure.sh with the executable and array size as arguments
        result = subprocess.run(['./measure.sh', executable, str(arr_size)], capture_output=True, text=True, check=True)
        
        # Assuming the output is the memory usage in bytes
        mem = float(result.stdout.strip())
        print(mem)
        print(f"Memory usage for {executable} with size {arr_size}: {mem} bytes")  # Debugging output
        return mem
    except subprocess.CalledProcessError as e:
        print(f"Error running {executable} with array size {arr_size}: {e}")
        return None
    except ValueError:
        print(f"Invalid output for {executable} with array size {arr_size}. Could not convert to float.")
        return None

# Function to get average memory usage by running the algorithm 3 times
def average_memory_usage(executable, arr_size, runs=3):
    usages = [get_memory_usage(executable, arr_size) for _ in range(runs)]
    # Filter out None values (in case of error) and return average
    usages = [usage for usage in usages if usage is not None]
    return sum(usages) / len(usages) if usages else 0

# List of input sizes to test
input_sizes = [1000, 5000, 10000, 20000, 40000, 50000, 60000, 80000,100000
  ,150000, 200000, 250000, 300000, 350000, 400000, 450000, 
               500000, 550000, 600000, 650000, 700000, 750000, 800000, 
               850000, 900000, 950000, 1000000]

# input_sizes = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41]

# input_sizes = list(range(10000,1000000, 20000))
memory_usage_algo_1 = []
memory_usage_algo_2 = []

# Collect average memory usage for Algorithm 1 (Executable 1) and Algorithm 2 (Executable 2)
for size in input_sizes:
    average_usage_algo_1 = average_memory_usage('./cmg1merge', size)
    memory_usage_algo_1.append(average_usage_algo_1 / (1024 * 1024))  # Convert to MB

for size in input_sizes:
    average_usage_algo_2 = average_memory_usage('./cmg2count', size)
    memory_usage_algo_2.append(average_usage_algo_2 / (1024 * 1024))  # Convert to MB

# Plotting the bar graph for memory usage
plt.figure(figsize=(12, 6))

# Set bar width
bar_width = 0.35
# Set positions of the bars on the x-axis
bar_positions = np.arange(len(input_sizes))

# Create bars for Algorithm 1 (Executable 1)
plt.bar(bar_positions - bar_width/2, memory_usage_algo_1, width=bar_width, label="Parallel Merge Sort", color='b')

# Create bars for Algorithm 2 (Executable 2)
plt.bar(bar_positions + bar_width/2, memory_usage_algo_2, width=bar_width, label="Parallel Count Sort", color='r')

# Adding labels and title
plt.xlabel("Input Size (number of elements)")
plt.ylabel("Average Memory Usage (MB)")
plt.title("Average Memory Usage Comparison of Parallel Count Sort and Parallel Merge Sort")

# Adding input size labels as x-ticks
plt.xticks(bar_positions, input_sizes, rotation=75)  # Rotate x-axis labels for readability

# Display the legend
plt.legend()

# Save the plot as a PNG file
plt.savefig("memory_comparision.png")

# Show the plot (optional, if you want to visualize it immediately)
plt.show()
