
# Question
# How does my current month's spending compare to the previous month?

# Methods

require 'aws-sdk-costexplorer'

# Initialize the AWS Cost Explorer client
# @param region [String] AWS region
# @param access_key_id [String] AWS access key ID
# @param secret_access_key [String] AWS secret access key
# @return [Aws::CostExplorer::Client] AWS Cost Explorer client
def cost_explorer_client(region, access_key_id, secret_access_key)
  Aws::CostExplorer::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Get the cost for a specific month
# @param cost_explorer [Aws::CostExplorer::Client] AWS Cost Explorer client
# @param year [Integer] Year of the month to get the cost for
# @param month [Integer] Month to get the cost for
# @return [Float] Cost for the specified month
def get_monthly_cost(cost_explorer, year, month)
  start_date = "#{year}-#{sprintf('%02d', month)}-01"
  end_date = (Date.parse(start_date) >> 1).strftime('%Y-%m-%d')
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

# Initialize the AWS Cost Explorer client
ce = cost_explorer_client(region, access_key_id, secret_access_key)

# Get the current date
now = Date.today

# Get the cost for the current month
current_month_cost = get_monthly_cost(ce, now.year, now.month)

# Get the cost for the previous month
previous_month_cost = get_monthly_cost(ce, now.prev_month.year, now.prev_month.month)

# Compare the costs
{ current_month_cost: current_month_cost, previous_month_cost: previous_month_cost }
