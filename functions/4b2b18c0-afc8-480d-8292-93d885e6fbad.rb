
# Question
# Do we have an ec2 instance doing a significantly larger workload than the others?

# Methods

require 'date'

# Fetches all EC2 instances
# @param ec2_client [Aws::EC2::Client] the EC2 client to use for fetching instances
# @return [Array<String>] an array of instance IDs
def get_all_ec2_instances(ec2_client)
  ec2_client.describe_instances.reservations.map(&:instances).flatten.map(&:instance_id)
end

# Fetches the average CPU Utilization for an instance over the past week
# @param instance_id [String] the ID of the instance to fetch CPU Utilization for
# @param cloudwatch_client [Aws::CloudWatch::Client] the CloudWatch client to use for fetching metrics
# @param start_time [Time] the start of the period to fetch metrics for
# @param end_time [Time] the end of the period to fetch metrics for
# @return [Float] the average CPU Utilization for the instance over the specified period
def get_avg_cpu_utilization(instance_id, cloudwatch_client, start_time, end_time)
  dimensions = [{ name: 'InstanceId', value: instance_id }]
  cloudwatch_average_over_time('AWS/EC2', 'CPUUtilization', dimensions, start_time, end_time)
end

# Calculates the standard deviation of an array of numbers
# @param array [Array<Number>] the array of numbers to calculate the standard deviation for
# @return [Float] the standard deviation of the array
def standard_deviation(array)
  n = array.length
  mean = array.inject(:+) / n.to_f
  variance = array.inject(0) { |variance, x| variance += (x - mean) ** 2 }
  Math.sqrt(variance/(n-1))
end

# Usage

# Set start_time and end_time for the past week
start_time = Time.now - 7*24*60*60
end_time = Time.now

# Get all EC2 instances
instances = get_all_ec2_instances(ec2_client)

# Get average CPU Utilization for each instance over the past week
avg_cpu_utilizations = instances.map { |instance_id| get_avg_cpu_utilization(instance_id, cloudwatch_client, start_time, end_time) }

# Calculate mean and standard deviation of CPU Utilizations
mean_cpu_utilization = avg_cpu_utilizations.inject(:+) / avg_cpu_utilizations.length.to_f
std_dev_cpu_utilization = standard_deviation(avg_cpu_utilizations)

# Find instances with CPU Utilization more than 1 standard deviation above the mean
high_workload_instances = instances.select do |instance_id|
  avg_cpu_utilization = get_avg_cpu_utilization(instance_id, cloudwatch_client, start_time, end_time)
  avg_cpu_utilization > mean_cpu_utilization + std_dev_cpu_utilization
end

high_workload_instances
