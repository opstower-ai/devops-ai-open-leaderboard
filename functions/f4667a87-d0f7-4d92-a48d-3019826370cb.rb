
# Question
# What are the our ec2 instance names?

# Methods

# Fetches all EC2 instances and their names using the provided EC2 client.
#
# @param ec2_client [Aws::EC2::Client] The EC2 client to use for fetching instances.
# @return [Array<Hash>] An array of hashes, with each hash containing the `id` and `name` of an EC2 instance.
def fetch_ec2_instance_names(ec2_client)
  # Fetch all instances
  instances = ec2_client.describe_instances.reservations.flat_map(&:instances)

  # Extract instance id and name (from tags)
  instances.map do |instance|
    name_tag = instance.tags.find { |tag| tag.key == 'Name' }
    name = name_tag ? name_tag.value : 'Unnamed'
    { id: instance.instance_id, name: name }
  end
end

# Usage

# Fetch all EC2 instances and their names using the provided EC2 client.
fetch_ec2_instance_names(ec2_client)
