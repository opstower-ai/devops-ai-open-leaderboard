
# Question
# How many reserved instances do I have, and how much am I being charged for each reserved instance?

# Methods

# Fetches reserved instances and their cost from AWS.
# @param ec2_client [Aws::EC2::Client] an instance of Aws::EC2::Client already initialized with the region, access_key_id, and secret_access_key
# @param region [String] the AWS region where the reserved instances are located
# @return [Array<Hash>] an array of hashes, each containing the instance_id and cost of a reserved instance
def fetch_reserved_instances_and_cost(ec2_client, region)
  # Fetch all reserved instances
  reserved_instances = ec2_client.describe_reserved_instances.reserved_instances

  # Initialize cost explorer client
  cost_explorer_client = Aws::CostExplorer::Client.new(region: region)

  # Fetch cost details for each reserved instance
  reserved_instances.map do |ri|
    cost = cost_explorer_client.get_cost_and_usage({
      time_period: {
        start: (Time.now - 30.days).strftime('%Y-%m-%d'),
        end: Time.now.strftime('%Y-%m-%d')
      },
      filter: {
        dimensions: {
          key: "RESERVATION_ID",
          values: [ri.reserved_instances_id]
        }
      },
      metrics: ["UnblendedCost"],
      granularity: "MONTHLY"
    }).results_by_time.first.total["UnblendedCost"].amount.to_f

    # Return a hash with the instance id and cost
    { instance_id: ri.reserved_instances_id, cost: cost }
  end
end

# Usage

# Fetch reserved instances and their cost
fetch_reserved_instances_and_cost(ec2_client, region)
