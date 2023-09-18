
# Question
# which s3 buckets do not have server access logging enabled?

# Methods

require 'aws-sdk-s3'

# Initializes an AWS S3 client with the provided region, access key ID, and secret access key.
#
# @param region [String] The AWS region to initialize the client in.
# @param access_key_id [String] The AWS access key ID to authenticate the client.
# @param secret_access_key [String] The AWS secret access key to authenticate the client.
# @return [Aws::S3::Client] The initialized AWS S3 client.
def initialize_s3_client(region, access_key_id, secret_access_key)
  Aws::S3::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Retrieves all bucket names from the provided AWS S3 client.
#
# @param s3_client [Aws::S3::Client] The AWS S3 client to retrieve bucket names from.
# @return [Array<String>] The names of all buckets in the AWS S3 client.
def get_all_bucket_names(s3_client)
  s3_client.list_buckets.buckets.map(&:name)
end

# Retrieves the names of buckets without logging enabled from the provided AWS S3 client and bucket names.
#
# @param s3_client [Aws::S3::Client] The AWS S3 client to check bucket logging status.
# @param bucket_names [Array<String>] The names of the buckets to check logging status.
# @return [Array<String>] The names of the buckets without logging enabled.
def get_buckets_without_logging(s3_client, bucket_names)
  bucket_names.select do |bucket_name|
    begin
      logging_status = s3_client.get_bucket_logging({ bucket: bucket_name }).logging_enabled
      logging_status.nil?
    rescue Aws::S3::Errors::NoSuchBucket
      next
    end
  end
end

# Usage

# Initialize the AWS S3 client
s3_client = initialize_s3_client(region, access_key_id, secret_access_key)

# Retrieve all bucket names from the AWS S3 client
bucket_names = get_all_bucket_names(s3_client)

# Retrieve the names of buckets without logging enabled
buckets_without_logging = get_buckets_without_logging(s3_client, bucket_names)

# Return the names of buckets without logging enabled
buckets_without_logging
