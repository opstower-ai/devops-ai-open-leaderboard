
# Question
# Are there any security groups with unrestricted access lists?

# Methods

# Checks if a security group has unrestricted access
# @param ip_permissions [Array<Hash>] An array of IP permissions associated with a security group
# @return [Boolean] Returns true if the security group has unrestricted access, false otherwise
def has_unrestricted_access?(ip_permissions)
  ip_permissions.any? do |permission|
    permission.ip_ranges.any? do |ip_range|
      ip_range.cidr_ip == '0.0.0.0/0'
    end
  end
end

# Fetches all security groups and checks if they have unrestricted access
# @param ec2_client [Aws::EC2::Client] An instance of Aws::EC2::Client already initialized with the region, access_key_id, and secret_access_key
# @return [Array<String>] Returns an array of security group IDs that have unrestricted access
def check_security_groups(ec2_client)
  response = ec2_client.describe_security_groups
  groups_with_unrestricted_access = []

  response.security_groups.each do |group|
    if has_unrestricted_access?(group.ip_permissions) || has_unrestricted_access?(group.ip_permissions_egress)
      groups_with_unrestricted_access << group.group_id
    end
  end

  groups_with_unrestricted_access
end

# Usage

# Call the method to check all security groups for unrestricted access
check_security_groups(ec2_client)
