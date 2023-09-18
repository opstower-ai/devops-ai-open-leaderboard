
# Question
# Are any ec2 instances offline?

# Methods

# Fetches all EC2 instances and checks their status.
#
# @param ec2_client [Aws::EC2::Client] The AWS EC2 client, already initialized with the region, access_key_id, and secret_access_key.
# @return [Array<String>] An array of instance IDs for instances that are not in the 'running' state.
def offline_instances(ec2_client)
  response = ec2_client.describe_instances
  offline_instances = []

  response.reservations.each do |reservation|
    reservation.instances.each do |instance|
      if instance.state.name != 'running'
        offline_instances << instance.instance_id
      end
    end
  end

  offline_instances
end

# Usage

# Call the method to get all offline instances
offline_instances(ec2_client)
