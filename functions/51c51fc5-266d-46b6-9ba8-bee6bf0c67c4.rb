
# Question
# are our rds db instances running the most current versions? if not, what versions are they running and what version is available?

# Methods

require 'aws-sdk-rds'

# Fetches all DB instances
#
# @param rds_client [Aws::RDS::Client] the AWS RDS client
# @return [Array<Aws::RDS::Types::DBInstance>] the DB instances
def fetch_db_instances(rds_client)
  rds_client.describe_db_instances.db_instances
end

# Fetches all versions of the specified DB engine
#
# @param rds_client [Aws::RDS::Client] the AWS RDS client
# @param engine [String] the DB engine
# @return [Array<Aws::RDS::Types::DBEngineVersion>] the DB engine versions
def fetch_db_engine_versions(rds_client, engine)
  rds_client.describe_db_engine_versions(engine: engine).db_engine_versions
end

# Checks the versions of all DB instances and compares them with the latest available version
#
# @param rds_client [Aws::RDS::Client] the AWS RDS client
# @return [Hash] a hash mapping DB instance identifiers to their engine, instance version, latest version, and whether they are up-to-date
def check_db_versions(rds_client)
  db_instances = fetch_db_instances(rds_client)
  db_versions = {}

  db_instances.each do |instance|
    engine = instance.engine
    instance_version = instance.engine_version

    # Fetch all versions of the DB engine
    engine_versions = fetch_db_engine_versions(rds_client, engine)

    # Find the latest version of the DB engine
    latest_version = engine_versions.max_by(&:engine_version).engine_version

    db_versions[instance.db_instance_identifier] = {
      engine: engine,
      instance_version: instance_version,
      latest_version: latest_version,
      is_latest: instance_version == latest_version
    }
  end

  db_versions
end

# Usage

rds_client = Aws::RDS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
check_db_versions(rds_client)
