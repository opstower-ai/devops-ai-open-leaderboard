
# Question
# how many total calls for each lambda function over the past 24 hours?

# Methods

require 'aws-sdk-lambda'

# Initializes an AWS Lambda client
#
# @param region [String] AWS region
# @param access_key_id [String] AWS access key ID
# @param secret_access_key [String] AWS secret access key
# @return [Aws::Lambda::Client] AWS Lambda client
def initialize_lambda_client(region, access_key_id, secret_access_key)
  Aws::Lambda::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
end

# Fetches all Lambda function names
#
# @param lambda_client [Aws::Lambda::Client] AWS Lambda client
# @return [Array<String>] List of Lambda function names
def fetch_lambda_function_names(lambda_client)
  lambda_client.list_functions.functions.map(&:function_name)
end

# Fetches total calls for each Lambda function over the past 24 hours
#
# @param cloudwatch_client [Aws::CloudWatch::Client] AWS CloudWatch client
# @param function_name [String] Name of the Lambda function
# @param start_time [Time] Start time for fetching the metric data
# @param end_time [Time] End time for fetching the metric data
# @return [Integer] Total calls for the Lambda function
def fetch_total_calls(cloudwatch_client, function_name, start_time, end_time)
  datapoints = cloudwatch_client.get_metric_statistics({
    namespace: 'AWS/Lambda',
    metric_name: 'Invocations',
    dimensions: [{ name: 'FunctionName', value: function_name }],
    start_time: start_time,
    end_time: end_time,
    period: 86400, # 24 hours in seconds
    statistics: ['Sum'],
  }).datapoints

  datapoints.empty? ? 0 : datapoints.first.sum
end

# Usage

start_time = Time.now - 86400 # 24 hours ago
end_time = Time.now

lambda_client = initialize_lambda_client(region, access_key_id, secret_access_key)
function_names = fetch_lambda_function_names(lambda_client)

function_names.each_with_object({}) do |function_name, result|
  result[function_name] = fetch_total_calls(cloudwatch_client, function_name, start_time, end_time)
end
