
# Question
# what is our largest s3 object in MB?

# Methods
require 'aws-sdk-s3'

# Initializes an AWS S3 client with the provided credentials.
#
# @param region [String] The AWS region.
# @param access_key_id [String] The AWS access key ID.
# @param secret_access_key [String] The AWS secret access key.
# @return [Aws::S3::Client] The initialized S3 client.
def initialize_s3_client(region, access_key_id, secret_access_key)
  Aws::S3::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Retrieves the names of all S3 buckets.
#
# @param s3_client [Aws::S3::Client] The S3 client.
# @return [Array<String>] The names of all S3 buckets.
def get_all_s3_buckets(s3_client)
  s3_client.list_buckets.buckets.map(&:name)
end

# Finds the largest object across all provided S3 buckets.
#
# @param s3_client [Aws::S3::Client] The S3 client.
# @param buckets [Array<String>] The names of the S3 buckets to search.
# @return [Hash] The largest object, including its size (in MB), key, and bucket name.
def get_largest_s3_object(s3_client, buckets)
  largest_object = { size: 0, key: nil, bucket: nil }

  buckets.each do |bucket|
    continuation_token = nil
    loop do
      response = s3_client.list_objects_v2(bucket: bucket, continuation_token: continuation_token)
      response.contents.each do |object|
        if object.size > largest_object[:size]
          # Store the size in bytes for comparison
          largest_object = { size: object.size, key: object.key, bucket: bucket }
        end
      end

      # Break out of the loop unless there's a continuation token (which means there are more objects to retrieve)
      continuation_token = response.next_continuation_token
      break unless continuation_token
    end
  end

  # Convert the size from bytes to megabytes
  largest_object[:size] = largest_object[:size] / 1024.0 / 1024.0

  largest_object
end


# Usage

s3_client = initialize_s3_client(region, access_key_id, secret_access_key)
buckets = get_all_s3_buckets(s3_client)
get_largest_s3_object(s3_client, buckets)
