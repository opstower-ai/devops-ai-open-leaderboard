
# Question
# Are all of our ec2 instances running?

# Methods

# Checks if all EC2 instances are running.
#
# @param ec2_client [Aws::EC2::Client] The AWS EC2 client object.
# @return [Boolean] Returns true if all instances are running, false otherwise.
def all_instances_running?(ec2_client)
  # Fetch all instances
  instances = ec2_client.describe_instances.reservations.map(&:instances).flatten

  # Check if all instances are in the 'running' state
  instances.all? { |instance| instance.state.name == 'running' }
end

# Usage

# Call the method to check if all EC2 instances are running
all_instances_running?(ec2_client)
