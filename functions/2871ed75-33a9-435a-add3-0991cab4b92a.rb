
# Question
# what is the percent Database capacity usage for each elasticcache instance?

# Methods

# Initializes an AWS ElastiCache client
# @param region [String] the AWS region
# @param access_key_id [String] the AWS access key ID
# @param secret_access_key [String] the AWS secret access key
# @return [Aws::ElastiCache::Client] the initialized AWS ElastiCache client
def elasticache_client(region, access_key_id, secret_access_key)
  Aws::ElastiCache::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
end

# Retrieves all cache cluster IDs
# @param elasticache_client [Aws::ElastiCache::Client] the AWS ElastiCache client
# @return [Array<String>] an array of cache cluster IDs
def get_all_cache_cluster_ids(elasticache_client)
  cache_cluster_ids = []
  elasticache_client.describe_cache_clusters.cache_clusters.each do |cache_cluster|
    cache_cluster_ids << cache_cluster.cache_cluster_id
  end
  cache_cluster_ids
end

# Retrieves the average database capacity usage for a specific cache cluster within a specified time range
# @param cloudwatch_client [Aws::CloudWatch::Client] the AWS CloudWatch client
# @param cache_cluster_id [String] the cache cluster ID
# @param start_time [Time] the start of the time range
# @param end_time [Time] the end of the time range
# @return [Float] the average database capacity usage
def get_database_capacity_usage(cloudwatch_client, cache_cluster_id, start_time, end_time)
  dimensions = [{ name: 'CacheClusterId', value: cache_cluster_id }]
  cloudwatch_average_over_time('AWS/ElastiCache', 'DatabaseMemoryUsagePercentage', dimensions, start_time, end_time)
end

# Retrieves the average database capacity usage for all cache clusters within a specified time range
# @param elasticache_client [Aws::ElastiCache::Client] the AWS ElastiCache client
# @param cloudwatch_client [Aws::CloudWatch::Client] the AWS CloudWatch client
# @param start_time [Time] the start of the time range
# @param end_time [Time] the end of the time range
# @return [Hash] a hash where the keys are the cache cluster IDs and the values are the corresponding average database capacity usages
def get_all_database_capacity_usages(elasticache_client, cloudwatch_client, start_time, end_time)
  cache_cluster_ids = get_all_cache_cluster_ids(elasticache_client)
  database_capacity_usages = {}
  cache_cluster_ids.each do |cache_cluster_id|
    database_capacity_usages[cache_cluster_id] = get_database_capacity_usage(cloudwatch_client, cache_cluster_id, start_time, end_time)
  end
  database_capacity_usages
end

# Usage

elasticache_client = elasticache_client(region, access_key_id, secret_access_key)
get_all_database_capacity_usages(elasticache_client, cloudwatch_client, start_time, end_time)
