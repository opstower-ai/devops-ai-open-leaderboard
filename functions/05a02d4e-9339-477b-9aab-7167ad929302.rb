
# Question
# How long are rds backups retained?

# Methods

# Require the AWS SDK for RDS
require 'aws-sdk-rds'

# Fetches the backup retention period for each Amazon RDS instance in a specific AWS region.
#
# @param region [String] The AWS region where the RDS instances are located.
# @param access_key_id [String] The AWS access key ID for authentication.
# @param secret_access_key [String] The AWS secret access key for authentication.
# @return [Array<Hash>] An array of hashes where each hash represents an RDS instance and its backup retention period.
def rds_backup_retention_period(region, access_key_id, secret_access_key)
  # Create a new RDS client
  rds_client = Aws::RDS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

  # Get all RDS instances
  rds_instances = rds_client.describe_db_instances.db_instances

  # Map each RDS instance to its backup retention period
  backup_retention_periods = rds_instances.map { |instance| { instance.db_instance_identifier => instance.backup_retention_period } }

  backup_retention_periods
end

# Usage

# Fetch the backup retention period for all RDS instances in a specific AWS region.
rds_backup_retention_period(region, access_key_id, secret_access_key)
