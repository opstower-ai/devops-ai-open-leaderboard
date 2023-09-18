
# Question
# How much have I spent on AWS this month so far?

# Methods

require 'aws-sdk-costexplorer'

# Initializes the AWS Cost Explorer client
# @param region [String] The AWS region
# @param access_key_id [String] The AWS access key ID
# @param secret_access_key [String] The AWS secret access key
# @return [Aws::CostExplorer::Client] The AWS Cost Explorer client
def cost_explorer_client(region, access_key_id, secret_access_key)
  Aws::CostExplorer::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Gets the cost incurred for the current month
# @param cost_explorer [Aws::CostExplorer::Client] The AWS Cost Explorer client
# @return [Float] The cost incurred for the current month
def get_monthly_cost(cost_explorer)
  start_date = Date.today.beginning_of_month.to_s
  end_date = Date.today.to_s

  response = cost_explorer.get_cost_and_usage({
    time_period: {
      start: start_date,
      end: end_date
    },
    granularity: 'MONTHLY',
    metrics: ['UnblendedCost']
  })

  response.results_by_time[0].total['UnblendedCost'].amount.to_f
end

# Usage

cost_explorer = cost_explorer_client(region, access_key_id, secret_access_key)
get_monthly_cost(cost_explorer)
