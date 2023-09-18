
# Question
# Which region has the highest AWS expenses for me over the past 3 months?

# Methods

require 'aws-sdk-costexplorer'

# Initializes the AWS Cost Explorer client
#
# @param region [String] the AWS region
# @param access_key_id [String] the AWS access key ID
# @param secret_access_key [String] the AWS secret access key
# @return [Aws::CostExplorer::Client] the AWS Cost Explorer client
def initialize_cost_explorer_client(region, access_key_id, secret_access_key)
  Aws::CostExplorer::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Retrieves the cost data by region
#
# @param cost_explorer_client [Aws::CostExplorer::Client] the AWS Cost Explorer client
# @param start_time [Time] the start time for the cost data
# @param end_time [Time] the end time for the cost data
# @return [Array<Aws::CostExplorer::Types::ResultByTime>] the cost data by region
def get_cost_by_region(cost_explorer_client, start_time, end_time)
  cost_explorer_client.get_cost_and_usage(
    {
      time_period: {
        start: start_time.strftime('%Y-%m-%d'),
        end: end_time.strftime('%Y-%m-%d')
      },
      granularity: 'MONTHLY',
      metrics: ['UnblendedCost'],
      group_by: [
        {
          type: 'DIMENSION',
          key: 'REGION'
        }
      ]
    }
  ).results_by_time.flat_map(&:groups)
end

# Finds the region with the highest cost
#
# @param cost_data [Array<Aws::CostExplorer::Types::ResultByTime>] the cost data by region
# @return [Aws::CostExplorer::Types::Group] the region with the highest cost
def find_region_with_highest_cost(cost_data)
  cost_data.max_by { |data| data.metrics['UnblendedCost'].amount.to_f }
end

# Usage

# Initialize the AWS Cost Explorer client
cost_explorer_client = initialize_cost_explorer_client(region, access_key_id, secret_access_key)

# Define the start and end time for the past 3 months
start_time = Time.now - 3*30*24*60*60
end_time = Time.now

# Get the cost data by region
cost_data = get_cost_by_region(cost_explorer_client, start_time, end_time)

# Find the region with the highest cost
region_with_highest_cost = find_region_with_highest_cost(cost_data)

region_with_highest_cost.keys.first
