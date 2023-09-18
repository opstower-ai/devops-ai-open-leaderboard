
# Question
# What was my total AWS bill for last month?

# Methods

# Fetches the total cost for the last month using AWS Cost Explorer service.
#
# @param costexplorer_client [Aws::CostExplorer::Client] an instance of Aws::CostExplorer::Client
#   already initialized with the region, access_key_id, and secret_access_key.
# @return [Float] the total cost of AWS services for the last month.
def fetch_last_month_total_cost(costexplorer_client)
  # Define the start and end dates for the last month
  end_date = Date.today.beginning_of_month.prev_day.to_s
  start_date = Date.today.beginning_of_month.prev_month.to_s

  # Fetch the cost and usage data for the last month
  response = costexplorer_client.get_cost_and_usage({
    time_period: {
      start: start_date,
      end: end_date
    },
    granularity: 'MONTHLY',
    metrics: ['UnblendedCost'],
  })

  # Parse and return the total cost
  response.results_by_time.first.total['UnblendedCost'].amount.to_f
end

# Usage

# Initialize a new instance of the AWS SDK's CostExplorer client
costexplorer_client = Aws::CostExplorer::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Fetch and return the total cost for the last month
fetch_last_month_total_cost(costexplorer_client)
