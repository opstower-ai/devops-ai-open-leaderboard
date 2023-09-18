
# Question
# how many EC2 instances have public IPs?

# Methods

# Fetches all EC2 instances from AWS.
#
# @param ec2_client [Aws::EC2::Client] The AWS EC2 client, initialized with region, access_key_id, and secret_access_key.
# @return [Array<Aws::EC2::Types::Instance>] An array of EC2 instance objects.
def get_all_ec2_instances(ec2_client)
  ec2_client.describe_instances.reservations.flat_map(&:instances)
end

# Counts the number of EC2 instances that have a public IP address.
#
# @param instances [Array<Aws::EC2::Types::Instance>] An array of EC2 instance objects.
# @return [Integer] The number of instances with a public IP address.
def count_instances_with_public_ips(instances)
  instances.count { |instance| instance.public_ip_address }
end

# Usage

# Fetch all EC2 instances
instances = get_all_ec2_instances(ec2_client)

# Count the number of instances that have a public IP address
count_instances_with_public_ips(instances)
