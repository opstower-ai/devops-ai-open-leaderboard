
# Question
# Is cloudtrail logging configured for each of our s3 buckets?

# Methods

require 'aws-sdk-s3'
require 'aws-sdk-cloudtrail'

# Initialize the clients
s3_client = Aws::S3::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
cloudtrail_client = Aws::CloudTrail::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Fetches all S3 bucket names.
# @param s3_client [Aws::S3::Client] the S3 client to use for the request.
# @return [Array<String>] an array of bucket names.
def get_all_s3_buckets(s3_client)
  s3_client.list_buckets.buckets.map(&:name)
end

# Fetches all CloudTrail trails.
# @param cloudtrail_client [Aws::CloudTrail::Client] the CloudTrail client to use for the request.
# @return [Array<Aws::CloudTrail::Types::Trail>] an array of trail objects.
def get_all_trails(cloudtrail_client)
  cloudtrail_client.describe_trails.trail_list
end

# Checks if logging is enabled for a specific bucket.
# @param bucket_name [String] the name of the bucket to check.
# @param trails [Array<Aws::CloudTrail::Types::Trail>] the trails to check against.
# @return [Boolean] true if logging is enabled for the bucket, false otherwise.
def is_logging_enabled_for_bucket(bucket_name, trails)
  trails.any? { |trail| trail.s3_bucket_name == bucket_name }
end

# Checks if logging is enabled for all S3 buckets.
# @param s3_client [Aws::S3::Client] the S3 client to use for the request.
# @param cloudtrail_client [Aws::CloudTrail::Client] the CloudTrail client to use for the request.
# @return [Hash] a hash where the keys are bucket names and the values are booleans indicating whether logging is enabled.
def check_s3_buckets_logging(s3_client, cloudtrail_client)
  buckets = get_all_s3_buckets(s3_client)
  trails = get_all_trails(cloudtrail_client)

  buckets.each_with_object({}) do |bucket, result|
    result[bucket] = is_logging_enabled_for_bucket(bucket, trails)
  end
end

# Usage

# Call the method to check if logging is enabled for all S3 buckets
check_s3_buckets_logging(s3_client, cloudtrail_client)
