
# Question
# Which service is costing me the most this month?

# Methods

require 'aws-sdk-costexplorer'

# Creates an AWS Cost Explorer client
#
# @param region [String] the AWS region
# @param access_key_id [String] the AWS access key ID
# @param secret_access_key [String] the AWS secret access key
# @return [Aws::CostExplorer::Client] the AWS Cost Explorer client
def cost_explorer_client(region, access_key_id, secret_access_key)
  Aws::CostExplorer::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Retrieves the cost of each AWS service within a specified time period
#
# @param cost_explorer [Aws::CostExplorer::Client] the AWS Cost Explorer client
# @param start_date [String] the start date of the time period in 'YYYY-MM-DD' format
# @param end_date [String] the end date of the time period in 'YYYY-MM-DD' format
# @return [Array<Aws::CostExplorer::Types::Group>] an array of groups, each representing a service and its cost
def get_service_costs(cost_explorer, start_date, end_date)
  cost_explorer.get_cost_and_usage({
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
  }).results_by_time[0].groups
end

# Finds the AWS service with the highest cost
#
# @param service_costs [Array<Aws::CostExplorer::Types::Group>] an array of groups, each representing a service and its cost
# @return [Aws::CostExplorer::Types::Group] the group representing the service with the highest cost
def highest_cost_service(service_costs)
  service_costs.max_by { |service| service.metrics['UnblendedCost'].amount.to_f }
end

# Usage

start_time = Time.now.beginning_of_month
end_time = Time.now
cost_explorer = cost_explorer_client(region, access_key_id, secret_access_key)
service_costs = get_service_costs(cost_explorer, start_time.strftime('%Y-%m-%d'), end_time.strftime('%Y-%m-%d'))
highest_cost_service(service_costs)
