
# Question
# What are the latency (ms) and error rates (errors/min) for each Lambda function over the past 7 days

# Methods

require 'aws-sdk-lambda'

# Initialize the AWS Lambda client
lambda_client = Aws::Lambda::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Method to get all Lambda function names
#
# @param lambda_client [Aws::Lambda::Client] Initialized AWS Lambda client
# @return [Array<String>] Array of Lambda function names
def get_lambda_function_names(lambda_client)
  lambda_client.list_functions.functions.map(&:function_name)
end

# Method to get average latency and error rates for a Lambda function
#
# @param function_name [String] Name of the Lambda function
# @param cloudwatch_client [Aws::CloudWatch::Client] Initialized AWS CloudWatch client
# @param start_time [Time] Start time for the metrics
# @param end_time [Time] End time for the metrics
# @return [Hash] Hash containing function name, average latency and average error rate
def get_lambda_metrics(function_name, cloudwatch_client, start_time, end_time)
  latency = cloudwatch_average_over_time('AWS/Lambda', 'Duration', [{ name: 'FunctionName', value: function_name }], start_time, end_time)
  error_rate = cloudwatch_average_over_time('AWS/Lambda', 'Errors', [{ name: 'FunctionName', value: function_name }], start_time, end_time)
  { function_name: function_name, average_latency: latency, average_error_rate: error_rate }
end

# Usage

# Set start_time and end_time for the past 7 days
start_time = Time.now - 7*24*60*60
end_time = Time.now

# Get all Lambda function names
function_names = get_lambda_function_names(lambda_client)

# Get average latency and error rates for each Lambda function
function_metrics = function_names.map do |function_name|
  get_lambda_metrics(function_name, cloudwatch_client, start_time, end_time)
end

function_metrics
