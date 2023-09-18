
# Question
# Can you show me a breakdown of my AWS costs by service for this year?

# Methods

require 'aws-sdk-costexplorer'

# Initializes the AWS Cost Explorer client
# @param region [String] AWS region
# @param access_key_id [String] AWS access key ID
# @param secret_access_key [String] AWS secret access key
# @return [Aws::CostExplorer::Client] AWS Cost Explorer client
def initialize_cost_explorer_client(region, access_key_id, secret_access_key)
  Aws::CostExplorer::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Retrieves the AWS costs by service for the current year
# @param cost_explorer_client [Aws::CostExplorer::Client] AWS Cost Explorer client
# @return [Array<Hash>] Array of hashes, each representing a time period and containing the total unblended cost for that period and a breakdown of costs by AWS service
def retrieve_costs_by_service(cost_explorer_client)
  start_date = Date.today.beginning_of_year.to_s
  end_date = Date.today.to_s

  cost_explorer_client.get_cost_and_usage({
    time_period: {
      start: start_date,
      end: end_date
    },
    granularity: 'MONTHLY',
    metrics: ['UnblendedCost'],
    group_by: [
      {
        type: 'DIMENSION',
        key: 'SERVICE'
      }
    ]
  }).results_by_time
end

# Usage

# Initialize the AWS Cost Explorer client
cost_explorer = initialize_cost_explorer_client(region, access_key_id, secret_access_key)

# Retrieve the AWS costs by service for the current year
retrieve_costs_by_service(cost_explorer)
