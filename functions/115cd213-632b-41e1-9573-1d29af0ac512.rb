
# Question
# What are the latency (ms) and error rates (errors/min) for each Lambda function?

# Methods

require 'aws-sdk-lambda'

# Initialize the AWS Lambda client
lambda_client = Aws::Lambda::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Fetches all Lambda functions
# @param lambda_client [Aws::Lambda::Client] the AWS Lambda client
# @return [Array<String>] an array of function names
def fetch_lambda_functions(lambda_client)
  lambda_client.list_functions.functions.map(&:function_name)
end

# Fetches latency and error rates for a given Lambda function
# @param function_name [String] the name of the Lambda function
# @param start_time [Time] the start time for the metrics
# @param end_time [Time] the end time for the metrics
# @param cloudwatch_client [Aws::CloudWatch::Client] the AWS CloudWatch client
# @return [Hash] a hash containing the function name, latency, and error rate
def fetch_lambda_metrics(function_name, start_time, end_time, cloudwatch_client)
  latency = cloudwatch_average_over_time('AWS/Lambda', 'Duration', [{ name: 'FunctionName', value: function_name }], start_time, end_time)
  error_rate = cloudwatch_average_over_time('AWS/Lambda', 'Errors', [{ name: 'FunctionName', value: function_name }], start_time, end_time)
  { function_name: function_name, latency: latency, error_rate: error_rate }
end

# Usage

start_time = Time.now - 3600 # 1 hour ago
end_time = Time.now

function_names = fetch_lambda_functions(lambda_client)
metrics = function_names.map { |function_name| fetch_lambda_metrics(function_name, start_time, end_time, cloudwatch_client) }
metrics
