
# Question
# What was my AWS bill yesterday?

# Methods

# Retrieves the cost for a specific date from AWS Cost Explorer.
# @param costexplorer_client [Aws::CostExplorer::Client] An instance of Aws::CostExplorer::Client already initialized with the region, access_key_id, and secret_access_key.
# @param date [Date] The date for which the cost is to be retrieved.
# @return [String] The total unblended cost for the specified date.
def get_cost_for_date(costexplorer_client, date)
  # Define the parameters for the get_cost_and_usage method
  params = {
    time_period: {
      start: date.to_s,
      end: (date + 1).to_s
    },
    granularity: 'DAILY',
    metrics: ['UnblendedCost']
  }

  # Call the get_cost_and_usage method and return the result
  costexplorer_client.get_cost_and_usage(params).results_by_time[0].total['UnblendedCost'].amount
end

# Usage

# Initialize a CostExplorer client
costexplorer_client = Aws::CostExplorer::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Define the date for which you want to get the cost
date = Date.yesterday

# Retrieve the cost for the specified date
get_cost_for_date(costexplorer_client, date)
