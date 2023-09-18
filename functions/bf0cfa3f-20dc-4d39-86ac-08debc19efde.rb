
# Question
# how many ec2 instances have detailed monitoring and how many do not?

# Methods

# Retrieves all EC2 instances from AWS.
#
# @param ec2_client [Aws::EC2::Client] An instance of Aws::EC2::Client already initialized with the region, access_key_id, and secret_access_key.
# @return [Array<Aws::EC2::Types::Instance>] Returns an array of Aws::EC2::Types::Instance objects representing all EC2 instances.
def get_all_ec2_instances(ec2_client)
  ec2_client.describe_instances.reservations.map(&:instances).flatten
end

# Counts the number of EC2 instances with detailed monitoring enabled.
#
# @param instances [Array<Aws::EC2::Types::Instance>] An array of Aws::EC2::Types::Instance objects representing all EC2 instances.
# @return [Integer] Returns the count of instances with detailed monitoring enabled.
def count_instances_with_detailed_monitoring(instances)
  instances.count { |instance| instance.monitoring.state == 'enabled' }
end

# Counts the number of EC2 instances with detailed monitoring disabled.
#
# @param instances [Array<Aws::EC2::Types::Instance>] An array of Aws::EC2::Types::Instance objects representing all EC2 instances.
# @return [Integer] Returns the count of instances with detailed monitoring disabled.
def count_instances_without_detailed_monitoring(instances)
  instances.count { |instance| instance.monitoring.state == 'disabled' }
end

# Usage

# Get all EC2 instances
instances = get_all_ec2_instances(ec2_client)

# Count instances with detailed monitoring
instances_with_detailed_monitoring = count_instances_with_detailed_monitoring(instances)

# Count instances without detailed monitoring
instances_without_detailed_monitoring = count_instances_without_detailed_monitoring(instances)

# Return the counts
{
  instances_with_detailed_monitoring: instances_with_detailed_monitoring,
  instances_without_detailed_monitoring: instances_without_detailed_monitoring
}
