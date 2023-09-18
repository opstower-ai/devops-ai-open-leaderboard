
# Question
# what is the write latency on rds instances over the past hour

# Methods

# Fetches all RDS instances in the specified region.
#
# @return [Array<String>] An array of RDS instance identifiers.
def fetch_rds_instances
  rds_client = Aws::RDS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
  rds_client.describe_db_instances.db_instances.map(&:db_instance_identifier)
end

# Fetches the write latency for a specific RDS instance over a specified time period.
#
# @param instance_id [String] The identifier of the RDS instance.
# @return [Float] The average write latency for the specified RDS instance.
def fetch_write_latency(instance_id)
  dimensions = [{ name: 'DBInstanceIdentifier', value: instance_id }]
  cloudwatch_average_over_time('AWS/RDS', 'WriteLatency', dimensions, start_time, end_time)
end

# Usage

# Fetch all RDS instances
instances = fetch_rds_instances

# Fetch write latency for each instance and return as a hash with instance identifiers as keys and latencies as values.
instances.map { |instance| [instance, fetch_write_latency(instance)] }.to_h
