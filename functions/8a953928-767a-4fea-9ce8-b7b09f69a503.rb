
# Question
# How many invocations per minute are being handled by Lambda over the past 7 days?

# Methods

require 'aws-sdk-lambda'

# Initialize the Lambda client
lambda_client = Aws::Lambda::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Method to get all Lambda function names
# @param lambda_client [Aws::Lambda::Client] the AWS Lambda client
# @return [Array<String>] an array of function names
def get_all_lambda_function_names(lambda_client)
  lambda_client.list_functions.functions.map(&:function_name)
end

# Method to get total invocations per minute for a Lambda function over a given time period
# @param cloudwatch_client [Aws::CloudWatch::Client] the AWS CloudWatch client
# @param function_name [String] the name of the Lambda function
# @param start_time [Time] the start time of the period
# @param end_time [Time] the end time of the period
# @return [Float] the number of invocations per minute
def get_invocations_per_minute_for_function(cloudwatch_client, function_name, start_time, end_time)
  total_invocations = cloudwatch_average_over_time('AWS/Lambda', 'Invocations', [{ name: 'FunctionName', value: function_name }], start_time, end_time)
  minutes_in_period = ((end_time - start_time) / 60).to_i
  total_invocations / minutes_in_period
end

# Method to get total invocations per minute for all Lambda functions over a given time period
# @param lambda_client [Aws::Lambda::Client] the AWS Lambda client
# @param cloudwatch_client [Aws::CloudWatch::Client] the AWS CloudWatch client
# @param start_time [Time] the start time of the period
# @param end_time [Time] the end time of the period
# @return [Float] the total number of invocations per minute
def get_total_invocations_per_minute(lambda_client, cloudwatch_client, start_time, end_time)
  function_names = get_all_lambda_function_names(lambda_client)
  function_names.sum { |function_name| get_invocations_per_minute_for_function(cloudwatch_client, function_name, start_time, end_time) }
end

# Usage

# Set the start and end times for the past 7 days
start_time = Time.current - 7.days
end_time = Time.current

# Call the method to get the total invocations per minute for all Lambda functions over the past 7 days
get_total_invocations_per_minute(lambda_client, cloudwatch_client, start_time, end_time)
