
# Question
# Are provisoned iops set for any of our rds instances?

# Methods

require 'aws-sdk-rds'

# Initializes an Amazon RDS client
# 
# @param region [String] The AWS region
# @param access_key_id [String] The AWS access key ID
# @param secret_access_key [String] The AWS secret access key
# @return [Aws::RDS::Client] An instance of Aws::RDS::Client
def initialize_rds_client(region, access_key_id, secret_access_key)
  Aws::RDS::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Checks if any RDS instance has provisioned IOPS set
# 
# @param rds_client [Aws::RDS::Client] An instance of Aws::RDS::Client
# @return [Boolean] Returns true if any RDS instance has provisioned IOPS set, false otherwise
def provisioned_iops_set?(rds_client)
  rds_instances = rds_client.describe_db_instances.db_instances
  rds_instances.any? { |instance| instance.iops.to_i > 0 }
end

# Usage

rds_client = initialize_rds_client(region, access_key_id, secret_access_key)
provisioned_iops_set?(rds_client)
