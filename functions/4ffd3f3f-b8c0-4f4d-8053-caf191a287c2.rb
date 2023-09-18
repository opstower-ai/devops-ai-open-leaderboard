
# Question
# Have each of our rds instances had a successful backup in the past 48 hours?

# Methods

# AWS RDS client is required to interact with AWS RDS service.
require 'aws-sdk-rds'

# Initializes and returns an instance of Aws::RDS::Client.
#
# @return [Aws::RDS::Client] an instance of Aws::RDS::Client.
def rds_client
  Aws::RDS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
end

# Fetches the list of all RDS instance identifiers.
#
# @return [Array<String>] an array of RDS instance identifiers.
def list_rds_instances
  rds_client.describe_db_instances.db_instances.map(&:db_instance_identifier)
end

# Fetches the latest restorable time of the given RDS instance.
#
# @param db_instance_id [String] the identifier of the RDS instance.
# @return [Time, nil] the latest restorable time of the RDS instance or nil if the instance does not exist.
def get_latest_backup_time(db_instance_id)
  rds_client.describe_db_instances({db_instance_identifier: db_instance_id}).db_instances.first&.latest_restorable_time
end

# Usage

start_time = Time.now - 48*60*60 # 48 hours ago
all_backups_successful = list_rds_instances.all? do |db_instance_id|
  latest_backup_time = get_latest_backup_time(db_instance_id)
  latest_backup_time && latest_backup_time > start_time
end
all_backups_successful
