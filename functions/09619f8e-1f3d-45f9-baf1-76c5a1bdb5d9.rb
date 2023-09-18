
# Question
# Do we have the correct amount of RIs active to cover our RDS and EC2 instances?

# Methods

require 'aws-sdk-rds'

# Initialize RDS client
rds_client = Aws::RDS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Method to retrieve all running EC2 instances
# @param ec2_client [Aws::EC2::Client] The AWS EC2 client
# @return [Array<Aws::EC2::Types::Instance>] The running EC2 instances
def get_running_ec2_instances(ec2_client)
  ec2_client.describe_instances({filters: [{name: "instance-state-name", values: ["running"]}]}).reservations.flat_map(&:instances)
end

# Method to retrieve all running RDS instances
# @param rds_client [Aws::RDS::Client] The AWS RDS client
# @return [Array<Aws::RDS::Types::DBInstance>] The running RDS instances
def get_running_rds_instances(rds_client)
  rds_client.describe_db_instances.db_instances.select { |db_instance| db_instance.db_instance_status == 'available' }
end

# Method to retrieve all active EC2 Reserved Instances
# @param ec2_client [Aws::EC2::Client] The AWS EC2 client
# @return [Array<Aws::EC2::Types::ReservedInstances>] The active EC2 Reserved Instances
def get_active_ec2_ris(ec2_client)
  ec2_client.describe_reserved_instances({filters: [{name: "state", values: ["active"]}]}).reserved_instances
end

# Method to retrieve all active RDS Reserved Instances
# @param rds_client [Aws::RDS::Client] The AWS RDS client
# @return [Array<Aws::RDS::Types::ReservedDBInstance>] The active RDS Reserved Instances
def get_active_rds_ris(rds_client)
  rds_client.describe_reserved_db_instances.reserved_db_instances.select { |ri| ri.state == 'active' }
end

# Method to check if the number and type of active Reserved Instances match the number and type of running instances
# @param ec2_client [Aws::EC2::Client] The AWS EC2 client
# @param rds_client [Aws::RDS::Client] The AWS RDS client
# @return [Hash] A hash containing the coverage status for EC2 and RDS instances
def check_ri_coverage(ec2_client, rds_client)
  running_ec2_instances = get_running_ec2_instances(ec2_client)
  running_rds_instances = get_running_rds_instances(rds_client)
  active_ec2_ris = get_active_ec2_ris(ec2_client)
  active_rds_ris = get_active_rds_ris(rds_client)

  ec2_coverage = running_ec2_instances.all? { |instance| active_ec2_ris.any? { |ri| ri.instance_type == instance.instance_type } }
  rds_coverage = running_rds_instances.all? { |instance| active_rds_ris.any? { |ri| ri.db_instance_class == instance.db_instance_class } }

  { ec2_coverage: ec2_coverage, rds_coverage: rds_coverage }
end

# Usage

# Invoke the method to check if the number and type of active Reserved Instances match the number and type of running instances
check_ri_coverage(ec2_client, rds_client)
