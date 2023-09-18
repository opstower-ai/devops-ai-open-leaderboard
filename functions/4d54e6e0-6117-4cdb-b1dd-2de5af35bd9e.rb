
# Question
# how much storage remains (In GB) on the ebs volumes used on our rds instances?

# Methods

require 'aws-sdk-rds'

# Initialize RDS client
rds_client = Aws::RDS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Fetches all RDS instances.
#
# @param rds_client [Aws::RDS::Client] The RDS client used to fetch the instances.
# @return [Array<Aws::RDS::Types::DBInstance>] The list of all RDS instances.
def get_all_rds_instances(rds_client)
  rds_client.describe_db_instances.db_instances
end

# Fetches the free storage space for each RDS instance.
#
# @param rds_client [Aws::RDS::Client] The RDS client used to fetch the instances.
# @param cloudwatch_client [Aws::CloudWatch::Client] The CloudWatch client used to fetch the metrics.
# @param start_time [Time] The start time of the period for the CloudWatch metrics.
# @param end_time [Time] The end time of the period for the CloudWatch metrics.
# @return [Hash<String, Float>] A hash mapping instance identifiers to their free storage space in bytes.
def get_free_storage_space(rds_client, cloudwatch_client, start_time, end_time)
  free_storage_space = {}
  get_all_rds_instances(rds_client).each do |instance|
    dimensions = [{ name: 'DBInstanceIdentifier', value: instance.db_instance_identifier }]
    free_storage_space[instance.db_instance_identifier] = cloudwatch_average_over_time('AWS/RDS', 'FreeStorageSpace', dimensions, start_time, end_time)
  end
  free_storage_space
end

# Converts a size in bytes to gigabytes.
#
# @param bytes [Float] The size in bytes.
# @return [Float] The size in gigabytes.
def convert_bytes_to_gb(bytes)
  bytes / (1024.0 * 1024.0 * 1024.0)
end

# Usage

# Fetch the free storage space for each RDS instance in bytes.
free_storage_space_in_bytes = get_free_storage_space(rds_client, cloudwatch_client, start_time, end_time)

# Convert the free storage space from bytes to gigabytes.
free_storage_space_in_gb = {}
free_storage_space_in_bytes.each do |instance_id, storage_space|
  free_storage_space_in_gb[instance_id] = convert_bytes_to_gb(storage_space)
end

free_storage_space_in_gb
