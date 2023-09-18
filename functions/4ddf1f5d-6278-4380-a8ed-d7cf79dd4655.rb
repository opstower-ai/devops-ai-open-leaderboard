
# Question
# How much did I spend on EC2 instances last month?

# Methods

# Retrieves the cost for EC2 instances for the last month using the AWS CostExplorer service.
# @param costexplorer_client [Aws::CostExplorer::Client] An instance of the AWS CostExplorer client.
# @param start_time [String] The start time for the cost retrieval period in 'YYYY-MM-DD' format.
# @param end_time [String] The end time for the cost retrieval period in 'YYYY-MM-DD' format.
# @return [Aws::CostExplorer::Types::GetCostAndUsageResponse] Returns an object containing the cost and usage information.
def get_ec2_cost_last_month(costexplorer_client, start_time, end_time)
  costexplorer_client.get_cost_and_usage({
    time_period: {
      start: start_time,
      end: end_time
    },
    granularity: 'MONTHLY',
    filter: {
      dimensions: {
        key: 'SERVICE',
        values: ['Amazon Elastic Compute Cloud - Compute']
      }
    },
    metrics: ['UnblendedCost']
  })
end

# Usage

# Initialize a Cost Explorer client
costexplorer_client = Aws::CostExplorer::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Set the start and end times for the last month
start_time = (Time.now - 1.month).beginning_of_month.strftime('%Y-%m-%d')
end_time = (Time.now - 1.month).end_of_month.strftime('%Y-%m-%d')

# Get the cost for EC2 instances for the last month
get_ec2_cost_last_month(costexplorer_client, start_time, end_time)
