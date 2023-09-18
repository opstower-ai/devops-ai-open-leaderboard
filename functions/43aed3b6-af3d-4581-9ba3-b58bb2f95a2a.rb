
# Question
# Are there any elasticcache instances?

# Methods

require 'aws-sdk-elasticache'

# Fetches details of all ElastiCache instances in a specific AWS region.
#
# @param access_key_id [String] AWS access key ID
# @param secret_access_key [String] AWS secret access key
# @param region [String] AWS region
# @return [Array<Hash>] An array of hashes, where each hash represents a cache cluster and contains details like cluster ID, node type, engine, status, etc.
def elasticache_instances(access_key_id, secret_access_key, region)
  # Initialize an AWS ElastiCache client with the given credentials and region
  elasticache = Aws::ElastiCache::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )

  # Call the describe_cache_clusters method on the client to fetch the details of all cache clusters
  response = elasticache.describe_cache_clusters

  # Return the details of all cache clusters
  response.cache_clusters
end

# Usage

elasticache_instances(access_key_id, secret_access_key, region)
