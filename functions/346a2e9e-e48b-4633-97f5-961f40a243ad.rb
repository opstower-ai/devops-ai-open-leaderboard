
# Question
# Are there any unused Lambdas?

# Methods

require 'aws-sdk-lambda'

# Creates a new AWS Lambda client
#
# @param region [String] the AWS region
# @param access_key_id [String] the AWS access key ID
# @param secret_access_key [String] the AWS secret access key
# @return [Aws::Lambda::Client] the AWS Lambda client
def create_lambda_client(region, access_key_id, secret_access_key)
  Aws::Lambda::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Retrieves all AWS Lambda functions
#
# @param lambda_client [Aws::Lambda::Client] the AWS Lambda client
# @return [Array<Aws::Lambda::Types::FunctionConfiguration>] the list of Lambda functions
def fetch_all_lambda_functions(lambda_client)
  lambda_client.list_functions.functions
end

# Retrieves the invocation count of a specific AWS Lambda function
#
# @param cloudwatch_client [Aws::CloudWatch::Client] the AWS CloudWatch client
# @param function_name [String] the name of the Lambda function
# @param start_time [Time] the start time for the metric data query
# @param end_time [Time] the end time for the metric data query
# @return [Integer] the invocation count of the Lambda function
def fetch_lambda_invocation_count(cloudwatch_client, function_name, start_time, end_time)
  metric_name = 'Invocations'
  namespace = 'AWS/Lambda'
  dimensions = [{ name: 'FunctionName', value: function_name }]

  statistics = cloudwatch_client.get_metric_statistics({
    namespace: namespace,
    metric_name: metric_name,
    dimensions: dimensions,
    start_time: start_time,
    end_time: end_time,
    period: 3600, # 1 hour
    statistics: ['Sum'],
  })

  statistics.datapoints.sum(&:sum) || 0
end

# Retrieves all unused AWS Lambda functions
#
# @param lambda_client [Aws::Lambda::Client] the AWS Lambda client
# @param cloudwatch_client [Aws::CloudWatch::Client] the AWS CloudWatch client
# @param start_time [Time] the start time for the metric data query
# @param end_time [Time] the end time for the metric data query
# @return [Array<Aws::Lambda::Types::FunctionConfiguration>] the list of unused Lambda functions
def fetch_unused_lambdas(lambda_client, cloudwatch_client, start_time, end_time)
  all_lambdas = fetch_all_lambda_functions(lambda_client)
  all_lambdas.select do |lambda_function|
    invocation_count = fetch_lambda_invocation_count(cloudwatch_client, lambda_function.function_name, start_time, end_time)
    invocation_count.zero?
  end
end

# Usage

lambda_client = create_lambda_client(region, access_key_id, secret_access_key)
start_time = Time.now - 30 * 24 * 60 * 60 # 30 days ago
end_time = Time.now
fetch_unused_lambdas(lambda_client, cloudwatch_client, start_time, end_time)
