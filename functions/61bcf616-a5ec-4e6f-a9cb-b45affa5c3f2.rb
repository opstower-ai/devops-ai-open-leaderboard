
# Question
# Are there any unencrypted storage/EBS volumes, or RDS backups?

# Methods

require 'aws-sdk-rds'

# Fetches all the unencrypted volumes from the provided EC2 client.
#
# @param ec2_client [Aws::EC2::Client] the EC2 client to fetch the volumes from.
# @return [Array<Aws::EC2::Types::Volume>] an array of unencrypted volumes.
def unencrypted_volumes(ec2_client)
  volumes = ec2_client.describe_volumes.volumes
  unencrypted_volumes = volumes.select { |volume| !volume.encrypted }
  unencrypted_volumes
end

# Fetches all the unencrypted RDS snapshots from the provided AWS region and credentials.
#
# @param region [String] the AWS region to fetch the RDS snapshots from.
# @param access_key_id [String] the AWS access key ID for authentication.
# @param secret_access_key [String] the AWS secret access key for authentication.
# @return [Array<Aws::RDS::Types::DBSnapshot>] an array of unencrypted RDS snapshots.
def unencrypted_rds_backups(region, access_key_id, secret_access_key)
  rds_client = Aws::RDS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
  snapshots = rds_client.describe_db_snapshots.db_snapshots
  unencrypted_snapshots = snapshots.select { |snapshot| !snapshot.encrypted }
  unencrypted_snapshots
end

# Usage

unencrypted_volumes = unencrypted_volumes(ec2_client)
unencrypted_rds_backups = unencrypted_rds_backups(region, access_key_id, secret_access_key)
[unencrypted_volumes, unencrypted_rds_backups]
