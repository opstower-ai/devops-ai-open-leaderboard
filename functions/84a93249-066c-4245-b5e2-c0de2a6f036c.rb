
# Question
# are there any lambdas that have not been called over the past 5 days?

# Methods

require 'aws-sdk-lambda'

# Initializes an AWS Lambda client
# @param region [String] AWS region
# @param access_key_id [String] AWS access key ID
# @param secret_access_key [String] AWS secret access key
# @return [Aws::Lambda::Client] Initialized AWS Lambda client
def initialize_lambda_client(region, access_key_id, secret_access_key)
  Aws::Lambda::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Fetches all AWS Lambda function names
# @param lambda_client [Aws::Lambda::Client] Initialized AWS Lambda client
# @return [Array<String>] List of all AWS Lambda function names
def get_all_lambda_functions(lambda_client)
  lambda_client.list_functions.functions.map(&:function_name)
end

# Fetches the number of invocations of a specific AWS Lambda function over a specific time period
# @param cloudwatch_client [Aws::CloudWatch::Client] Initialized AWS CloudWatch client
# @param function_name [String] Name of the AWS Lambda function
# @param start_time [Time] Start time of the period
# @param end_time [Time] End time of the period
# @return [Integer] Number of invocations of the function over the time period
def get_lambda_invocations(cloudwatch_client, function_name, start_time, end_time)
  dimensions = [{ name: 'FunctionName', value: function_name }]
  cloudwatch_average_over_time('AWS/Lambda', 'Invocations', dimensions, start_time, end_time)
end

# Fetches the names of all AWS Lambda functions that have not been invoked over a specific time period
# @param lambda_client [Aws::Lambda::Client] Initialized AWS Lambda client
# @param cloudwatch_client [Aws::CloudWatch::Client] Initialized AWS CloudWatch client
# @param start_time [Time] Start time of the period
# @param end_time [Time] End time of the period
# @return [Array<String>] List of names of unused AWS Lambda functions
def get_unused_lambdas(lambda_client, cloudwatch_client, start_time, end_time)
  all_functions = get_all_lambda_functions(lambda_client)
  all_functions.select do |function|
    invocations = get_lambda_invocations(cloudwatch_client, function, start_time, end_time)
    invocations == 0
  end
end

# Usage

# Initialize the Lambda client
lambda_client = initialize_lambda_client(region, access_key_id, secret_access_key)

# Set the start and end time for the past 5 days
start_time = Time.now - 5*24*60*60
end_time = Time.now

# Get the list of unused Lambda functions
get_unused_lambdas(lambda_client, cloudwatch_client, start_time, end_time)
