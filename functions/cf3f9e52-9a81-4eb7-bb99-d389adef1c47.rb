
# Question
# What is the average cpu utilization of our ec2 instances over the past 24 hours?

# Methods

# Fetches all EC2 instance ids
#
# @param ec2_client [Aws::EC2::Client] The EC2 client used to interact with AWS
# @return [Array<String>] An array of EC2 instance ids
def fetch_all_ec2_instance_ids(ec2_client)
  ec2_client.describe_instances.reservations.flat_map do |reservation|
    reservation.instances.map(&:instance_id)
  end
end

# Calculates the average CPU utilization for each EC2 instance
#
# @param cloudwatch_client [Aws::CloudWatch::Client] The CloudWatch client used to interact with AWS
# @param instance_ids [Array<String>] An array of EC2 instance ids
# @param start_time [Time] The start time for the period to calculate average CPU utilization
# @param end_time [Time] The end time for the period to calculate average CPU utilization
# @return [Hash] A hash where the keys are instance ids and the values are the average CPU utilization for that instance
def calculate_average_cpu_utilization_per_instance(cloudwatch_client, instance_ids, start_time, end_time)
  instance_ids.map do |instance_id|
    average_cpu_utilization = cloudwatch_average_over_time(
      'AWS/EC2',
      'CPUUtilization',
      [{ name: 'InstanceId', value: instance_id }],
      start_time,
      end_time
    )
    [instance_id, average_cpu_utilization]
  end.to_h
end

# Calculates the overall average CPU utilization
#
# @param cpu_utilization_per_instance [Hash] A hash where the keys are instance ids and the values are the average CPU utilization for that instance
# @return [Float] The overall average CPU utilization
def calculate_overall_average_cpu_utilization(cpu_utilization_per_instance)
  total_cpu_utilization = cpu_utilization_per_instance.values.sum
  total_instances = cpu_utilization_per_instance.keys.size
  total_cpu_utilization / total_instances
end

# Usage

start_time = Time.now - 24*60*60 # 24 hours ago
end_time = Time.now

instance_ids = fetch_all_ec2_instance_ids(ec2_client)
cpu_utilization_per_instance = calculate_average_cpu_utilization_per_instance(cloudwatch_client, instance_ids, start_time, end_time)
overall_average_cpu_utilization = calculate_overall_average_cpu_utilization(cpu_utilization_per_instance)

overall_average_cpu_utilization
