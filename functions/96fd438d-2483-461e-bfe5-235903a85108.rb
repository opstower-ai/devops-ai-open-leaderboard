
# Question
# Are there any publicly accessible S3 buckets?

# Methods

# Require the AWS SDK for S3
require 'aws-sdk-s3'

# Initialize the S3 client
s3_client = Aws::S3::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Checks if a specific S3 bucket is publicly accessible.
#
# @param bucket_name [String] The name of the bucket to check.
# @param s3_client [Aws::S3::Client] The AWS S3 client used to interact with the AWS S3 service.
# @return [Boolean] Returns true if the bucket is publicly accessible, false otherwise.
def bucket_public?(bucket_name, s3_client)
  acl = s3_client.get_bucket_acl({bucket: bucket_name})
  acl.grants.each do |grant|
    if grant.grantee.uri == "http://acs.amazonaws.com/groups/global/AllUsers" || grant.grantee.uri == "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
      return true
    end
  end
  false
end

# Retrieves all S3 buckets and checks if they are publicly accessible.
#
# @param s3_client [Aws::S3::Client] The AWS S3 client used to interact with the AWS S3 service.
# @return [Array<String>] Returns an array of names of all publicly accessible S3 buckets.
def get_public_buckets(s3_client)
  public_buckets = []
  s3_client.list_buckets.buckets.each do |bucket|
    if bucket_public?(bucket.name, s3_client)
      public_buckets << bucket.name
    end
  end
  public_buckets
end

# Usage

# Retrieves all publicly accessible S3 buckets.
get_public_buckets(s3_client)
