
# Question
# What's the minimum Burst Balance across ebs volumes?

# Methods

# Fetches all EBS volumes
#
# @param ec2_client [Aws::EC2::Client] AWS EC2 client instance that is used to interact with the Amazon EC2 service.
# @return [Array<String>] An array of EBS volume IDs.
def fetch_all_ebs_volumes(ec2_client)
  ec2_client.describe_volumes.volumes.map(&:volume_id)
end

# Fetches the burst balance for a given EBS volume over a specified time period.
#
# @param cloudwatch_client [Aws::CloudWatch::Client] AWS CloudWatch client instance that is used to interact with the Amazon CloudWatch service.
# @param volume_id [String] The ID of the EBS volume for which to fetch the burst balance.
# @param start_time [Time] The start of the time period for which to fetch the burst balance.
# @param end_time [Time] The end of the time period for which to fetch the burst balance.
# @return [Float] The average burst balance for the given EBS volume over the specified time period.
def fetch_burst_balance(cloudwatch_client, volume_id, start_time, end_time)
  dimensions = [{ name: 'VolumeId', value: volume_id }]
  cloudwatch_average_over_time('AWS/EBS', 'BurstBalance', dimensions, start_time, end_time)
end

# Finds the minimum burst balance across all EBS volumes over a specified time period.
#
# @param ec2_client [Aws::EC2::Client] AWS EC2 client instance that is used to interact with the Amazon EC2 service.
# @param cloudwatch_client [Aws::CloudWatch::Client] AWS CloudWatch client instance that is used to interact with the Amazon CloudWatch service.
# @param start_time [Time] The start of the time period for which to find the minimum burst balance.
# @param end_time [Time] The end of the time period for which to find the minimum burst balance.
# @return [Float] The minimum burst balance across all EBS volumes over the specified time period.
def find_min_burst_balance(ec2_client, cloudwatch_client, start_time, end_time)
  volume_ids = fetch_all_ebs_volumes(ec2_client)
  min_burst_balance = 100.0
  volume_ids.each do |volume_id|
    burst_balance = fetch_burst_balance(cloudwatch_client, volume_id, start_time, end_time)
    min_burst_balance = burst_balance if burst_balance < min_burst_balance
  end
  min_burst_balance
end

# Usage

# Set start_time and end_time to represent today
start_time = Time.current.beginning_of_day
end_time = Time.current.end_of_day

# Call the method to find the minimum burst balance across all EBS volumes
find_min_burst_balance(ec2_client, cloudwatch_client, start_time, end_time)
