
# Question
# Which ec2 instance has the highest total disk read and writes (in MB/sec)?

# Methods

# Retrieves all instance IDs from the AWS EC2 client.
#
# @param ec2_client [Aws::EC2::Client] The AWS EC2 client.
# @return [Array<String>] An array of instance IDs.
def get_all_instance_ids(ec2_client)
  instance_ids = []
  ec2_client.describe_instances.reservations.each do |reservation|
    reservation.instances.each do |instance|
      instance_ids << instance.instance_id
    end
  end
  instance_ids
end

# Retrieves the average disk read/write metrics for a given instance over a specified time period.
#
# @param cloudwatch_client [Aws::CloudWatch::Client] The AWS CloudWatch client.
# @param instance_id [String] The ID of the instance.
# @param start_time [Time] The start of the time period.
# @param end_time [Time] The end of the time period.
# @return [Float] The average disk read/write metrics in MB per second.
def get_disk_read_write_metrics(cloudwatch_client, instance_id, start_time, end_time)
  read_bytes = cloudwatch_average_over_time('AWS/EC2', 'DiskReadBytes', [{ name: 'InstanceId', value: instance_id }], start_time, end_time)
  write_bytes = cloudwatch_average_over_time('AWS/EC2', 'DiskWriteBytes', [{ name: 'InstanceId', value: instance_id }], start_time, end_time)
  total_bytes = read_bytes + write_bytes
  total_mb_per_sec = total_bytes / (1024.0 * 1024.0)
  total_mb_per_sec
end

# Finds the instance with the highest disk read/write value over a specified time period.
#
# @param ec2_client [Aws::EC2::Client] The AWS EC2 client.
# @param cloudwatch_client [Aws::CloudWatch::Client] The AWS CloudWatch client.
# @param start_time [Time] The start of the time period.
# @param end_time [Time] The end of the time period.
# @return [Hash] A hash with the instance ID and the highest disk read/write value.
def get_instance_with_highest_disk_rw(ec2_client, cloudwatch_client, start_time, end_time)
  instance_ids = get_all_instance_ids(ec2_client)
  highest_rw_instance_id = nil
  highest_rw_value = 0
  instance_ids.each do |instance_id|
    rw_value = get_disk_read_write_metrics(cloudwatch_client, instance_id, start_time, end_time)
    if rw_value > highest_rw_value
      highest_rw_value = rw_value
      highest_rw_instance_id = instance_id
    end
  end
  { instance_id: highest_rw_instance_id, rw_value: highest_rw_value }
end

# Usage

start_time = Time.now - 3600 # 1 hour ago
end_time = Time.now
get_instance_with_highest_disk_rw(ec2_client, cloudwatch_client, start_time, end_time)
