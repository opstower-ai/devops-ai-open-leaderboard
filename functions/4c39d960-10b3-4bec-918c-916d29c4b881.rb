
# Question
# Which ec2 instances have an average cpu utilization greater than 70% over the past day?

# Methods

# Fetches all EC2 instances.
#
# @param ec2_client [Aws::EC2::Client] The EC2 client to use for fetching instances.
# @return [Array<Aws::EC2::Types::Instance>] An array of all EC2 instances.
def fetch_all_instances(ec2_client)
  ec2_client.describe_instances.reservations.map(&:instances).flatten
end

# Calculates the average CPU utilization for each instance and returns instances with CPU utilization over 70%.
#
# @param instances [Array<Aws::EC2::Types::Instance>] The instances for which to calculate CPU utilization.
# @param cloudwatch_client [Aws::CloudWatch::Client] The CloudWatch client to use for fetching CPU utilization data.
# @param start_time [Time] The start time for the period over which to calculate CPU utilization.
# @param end_time [Time] The end time for the period over which to calculate CPU utilization.
# @return [Array<String>] An array of instance IDs for instances with CPU utilization over 70%.
def calculate_cpu_utilization(instances, cloudwatch_client, start_time, end_time)
  instances_with_high_cpu = []

  instances.each do |instance|
    average_cpu_utilization = cloudwatch_average_over_time('AWS/EC2', 'CPUUtilization', [{ name: 'InstanceId', value: instance.instance_id }], start_time, end_time)
    instances_with_high_cpu << instance.instance_id if average_cpu_utilization > 70
  end

  instances_with_high_cpu
end

# Usage

# Set start_time and end_time for the past day
start_time = Time.now - 86400
end_time = Time.now

# Fetch all instances
instances = fetch_all_instances(ec2_client)

# Calculate average CPU utilization for each instance and return instances with CPU utilization > 70%
calculate_cpu_utilization(instances, cloudwatch_client, start_time, end_time)
