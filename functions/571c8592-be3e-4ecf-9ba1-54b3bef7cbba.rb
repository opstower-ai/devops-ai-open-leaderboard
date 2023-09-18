
# Question
# Which instances have status check failures over the past 7 days?

# Methods

# AWS SDK libraries are already required in the execution environment.
# No need to require them again.

# Fetches all instance IDs from the AWS EC2 client.
#
# @param ec2_client [Aws::EC2::Client] The EC2 client to fetch instance IDs from.
# @return [Array<String>] An array of instance IDs.
def fetch_instance_ids(ec2_client)
  instance_ids = []
  # Iterate over each reservation and instance to collect instance IDs.
  ec2_client.describe_instances.reservations.each do |reservation|
    reservation.instances.each do |instance|
      instance_ids << instance.instance_id
    end
  end
  instance_ids
end

# Fetches the IDs of instances that have failed status checks within a specified time range.
#
# @param cloudwatch_client [Aws::CloudWatch::Client] The CloudWatch client to fetch metric data from.
# @param instance_ids [Array<String>] An array of instance IDs to check status for.
# @param start_time [Time] The start of the time range to check status for.
# @param end_time [Time] The end of the time range to check status for.
# @return [Array<String>] An array of instance IDs that have failed status checks.
def fetch_status_check_failed_instances(cloudwatch_client, instance_ids, start_time, end_time)
  failed_instances = []
  # Iterate over each instance ID to fetch metric data and check for failed status.
  instance_ids.each do |instance_id|
    metric_data = cloudwatch_client.get_metric_statistics({
      namespace: 'AWS/EC2',
      metric_name: 'StatusCheckFailed',
      dimensions: [{ name: 'InstanceId', value: instance_id }],
      start_time: start_time,
      end_time: end_time,
      period: 3600,
      statistics: ['Sum'],
      unit: 'Count'
    })
    # If any datapoint has a sum greater than 0, the instance has failed status checks.
    unless metric_data.datapoints.empty?
      failed_instances << instance_id if metric_data.datapoints.any? { |datapoint| datapoint.sum > 0 }
    end
  end
  failed_instances
end

# Usage

# Set the start and end times for the status check.
start_time = Time.now - 7*24*60*60 # 7 days ago
end_time = Time.now
# Fetch all instance IDs from the EC2 client.
instance_ids = fetch_instance_ids(ec2_client)
# Fetch the IDs of instances that have failed status checks within the specified time range.
fetch_status_check_failed_instances(cloudwatch_client, instance_ids, start_time, end_time)
