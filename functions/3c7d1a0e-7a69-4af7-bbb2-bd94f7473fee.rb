
# Question
# Do we have RDS read replicas?

# Methods

require 'aws-sdk-rds'

# Creates a new AWS RDS client
# 
# @param region [String] AWS region
# @param access_key_id [String] AWS access key ID
# @param secret_access_key [String] AWS secret access key
# @return [Aws::RDS::Client] the initialized AWS RDS client
def create_rds_client(region, access_key_id, secret_access_key)
  Aws::RDS::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Retrieves all DB instances from the provided RDS client
# 
# @param rds_client [Aws::RDS::Client] the AWS RDS client
# @return [Array<Aws::RDS::Types::DBInstance>] the array of DB instances
def fetch_all_db_instances(rds_client)
  rds_client.describe_db_instances.db_instances
end

# Filters the provided DB instances to only include read replicas
# 
# @param db_instances [Array<Aws::RDS::Types::DBInstance>] the array of DB instances
# @return [Array<Aws::RDS::Types::DBInstance>] the array of read replica DB instances
def filter_read_replicas(db_instances)
  db_instances.select { |instance| instance.read_replica_source_db_instance_identifier }
end

# Usage

rds = create_rds_client(region, access_key_id, secret_access_key)
db_instances = fetch_all_db_instances(rds)
read_replicas = filter_read_replicas(db_instances)
read_replicas
