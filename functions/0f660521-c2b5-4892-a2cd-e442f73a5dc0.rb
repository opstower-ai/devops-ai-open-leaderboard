
# Question
# what is the peak swap memory usage (IN MB) and cpu usage of each rds instance over the past 7 days?

# Methods

# AWS RDS client creation
# @param region [String] AWS region
# @param access_key_id [String] AWS access key ID
# @param secret_access_key [String] AWS secret access key
# @return [Aws::RDS::Client] AWS RDS client
def rds_client(region, access_key_id, secret_access_key)
  Aws::RDS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
end

# Fetches all RDS instances
# @param rds_client [Aws::RDS::Client] AWS RDS client
# @return [Array<String>] Array of RDS instance identifiers
def get_rds_instances(rds_client)
  rds_instances = []
  rds_client.describe_db_instances.db_instances.each do |db_instance|
    rds_instances << db_instance.db_instance_identifier
  end
  rds_instances
end

# Fetches peak memory and CPU usage for a given RDS instance
# @param cloudwatch_client [Aws::CloudWatch::Client] AWS CloudWatch client
# @param rds_instance [String] RDS instance identifier
# @param start_time [Time] Start time for fetching metrics
# @param end_time [Time] End time for fetching metrics
# @return [Hash] Hash containing peak swap memory usage in MB and peak CPU usage in percent
def get_peak_memory_and_cpu_usage(cloudwatch_client, rds_instance, start_time, end_time)
  swap_memory_usage = cloudwatch_client.get_metric_statistics({
    namespace: 'AWS/RDS',
    metric_name: 'SwapUsage',
    dimensions: [
      {
        name: 'DBInstanceIdentifier',
        value: rds_instance
      }
    ],
    start_time: start_time,
    end_time: end_time,
    period: 3600,
    statistics: ['Maximum'],
    unit: 'Bytes'
  }).datapoints.map(&:maximum).max.to_f / (1024 * 1024) # Convert Bytes to MB

  cpu_usage = cloudwatch_client.get_metric_statistics({
    namespace: 'AWS/RDS',
    metric_name: 'CPUUtilization',
    dimensions: [
      {
        name: 'DBInstanceIdentifier',
        value: rds_instance
      }
    ],
    start_time: start_time,
    end_time: end_time,
    period: 3600,
    statistics: ['Maximum'],
    unit: 'Percent'
  }).datapoints.map(&:maximum).max

  { rds_instance => { peak_swap_memory_usage_mb: swap_memory_usage, peak_cpu_usage_percent: cpu_usage } }
end

# Usage

rds = rds_client(region, access_key_id, secret_access_key)
rds_instances = get_rds_instances(rds)
start_time = Time.now - 7*24*60*60 # 7 days ago
end_time = Time.now

rds_instances.map do |rds_instance|
  get_peak_memory_and_cpu_usage(cloudwatch_client, rds_instance, start_time, end_time)
end
