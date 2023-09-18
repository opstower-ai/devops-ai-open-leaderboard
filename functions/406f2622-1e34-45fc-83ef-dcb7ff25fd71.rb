
# Question
# Do each of our RDS instances have backups enabled?

# Methods

require 'aws-sdk-rds'

# Initializes and returns an AWS RDS client
#
# @param region [String] the AWS region
# @param access_key_id [String] the AWS access key ID
# @param secret_access_key [String] the AWS secret access key
# @return [Aws::RDS::Client] the initialized AWS RDS client
def rds_client(region, access_key_id, secret_access_key)
  Aws::RDS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
end

# Retrieves all RDS instances
#
# @param rds [Aws::RDS::Client] the AWS RDS client
# @return [Array<Aws::RDS::DBInstance>] an array of all RDS instances
def get_all_rds_instances(rds)
  rds.describe_db_instances.db_instances
end

# Checks if backups are enabled for each RDS instance
#
# @param rds_instances [Array<Aws::RDS::DBInstance>] an array of RDS instances
# @return [Array<Hash>] an array of hashes, each containing the instance ID and a boolean indicating whether backups are enabled
def check_backups_enabled(rds_instances)
  rds_instances.map do |instance|
    {
      instance_id: instance.db_instance_identifier,
      backups_enabled: instance.backup_retention_period.positive?
    }
  end
end

# Usage

rds = rds_client(region, access_key_id, secret_access_key)
instances = get_all_rds_instances(rds)
check_backups_enabled(instances)
