
# Question
# How many replicas are configured for Elasticache?

# Methods

require 'aws-sdk-elasticache'

# Creates an instance of the AWS ElastiCache Client.
#
# @param region [String] the AWS region
# @param access_key_id [String] the AWS access key ID
# @param secret_access_key [String] the AWS secret access key
# @return [Aws::ElastiCache::Client] an instance of the AWS ElastiCache Client
def create_elasticache_client(region, access_key_id, secret_access_key)
  Aws::ElastiCache::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
end

# Fetches the total count of replicas across all replication groups.
#
# @param elasticache_client [Aws::ElastiCache::Client] an instance of the AWS ElastiCache Client
# @return [Integer] the total count of replicas
def fetch_replica_count(elasticache_client)
  replica_count = 0
  elasticache_client.describe_replication_groups.replication_groups.each do |replication_group|
    replica_count += replication_group.node_groups.first.node_group_members.count - 1
  end
  replica_count
end

# Usage

elasticache_client = create_elasticache_client(region, access_key_id, secret_access_key)
fetch_replica_count(elasticache_client)
