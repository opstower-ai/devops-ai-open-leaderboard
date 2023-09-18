
# Question
# Which ec2 instance has the highest total disk read and writes (in MB/sec) over the past hour?

# Methods

# Fetches all running EC2 instances
# @param ec2_client [Aws::EC2::Client] an instance of Aws::EC2::Client
# @return [Array<String>] an array of instance ids
def fetch_running_instances(ec2_client)
  instances = []
  ec2_client.describe_instances(filters: [{ name: 'instance-state-name', values: ['running'] }]).reservations.each do |reservation|
    reservation.instances.each do |instance|
      instances << instance.instance_id
    end
  end
  instances
end

# Calculates total disk read and write in MB/sec for each instance
# @param cloudwatch_client [Aws::CloudWatch::Client] an instance of Aws::CloudWatch::Client
# @param instance_id [String] the id of the instance
# @param start_time [Time] the start time for the calculation
# @param end_time [Time] the end time for the calculation
# @return [Float] the total disk activity in MB/sec
def calculate_disk_activity(cloudwatch_client, instance_id, start_time, end_time)
  read_bytes = cloudwatch_average_over_time('AWS/EC2', 'DiskReadBytes', [{ name: 'InstanceId', value: instance_id }], start_time, end_time)
  write_bytes = cloudwatch_average_over_time('AWS/EC2', 'DiskWriteBytes', [{ name: 'InstanceId', value: instance_id }], start_time, end_time)
  total_disk_activity = (read_bytes + write_bytes) / (1024 * 1024) # Convert bytes to MB
  total_disk_activity
end

# Usage

# Set start_time and end_time for the past hour
start_time = Time.current - 1.hour
end_time = Time.current

# Fetch all running instances
instances = fetch_running_instances(ec2_client)

# Calculate total disk activity for each instance and find the instance with highest disk activity
highest_disk_activity = { instance_id: nil, disk_activity: 0 }
instances.each do |instance_id|
  disk_activity = calculate_disk_activity(cloudwatch_client, instance_id, start_time, end_time)
  if disk_activity > highest_disk_activity[:disk_activity]
    highest_disk_activity = { instance_id: instance_id, disk_activity: disk_activity }
  end
end

highest_disk_activity
