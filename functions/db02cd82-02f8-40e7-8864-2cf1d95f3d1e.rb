
# Question
# What are the names of our rds instances?

# Methods

require 'aws-sdk-rds'

# Fetches the names of all RDS instances in a given AWS region.
#
# @param region [String] The AWS region to fetch RDS instance names from.
# @param access_key_id [String] The access key ID for AWS authentication.
# @param secret_access_key [String] The secret access key for AWS authentication.
# @return [Array<String>] An array of RDS instance names.
def fetch_rds_instance_names(region, access_key_id, secret_access_key)
  # Initialize an RDS client with the provided region and credentials.
  rds_client = Aws::RDS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

  # Fetch the details of all RDS instances in the region.
  rds_instances = rds_client.describe_db_instances.db_instances

  # Map the list of RDS instances to their names (identifiers).
  rds_instances.map(&:db_instance_identifier)
end

# Usage

# Fetch the names of all RDS instances in the provided AWS region.
fetch_rds_instance_names(region, access_key_id, secret_access_key)
