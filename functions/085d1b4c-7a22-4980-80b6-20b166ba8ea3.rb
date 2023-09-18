
# Question
# How many invocations per minute are being handled by Lambda?

# Methods

require 'aws-sdk-lambda'
require 'aws-sdk-cloudwatch'

# Retrieves the names of all AWS Lambda functions.
#
# @return [Array<String>] an array of AWS Lambda function names.
def get_lambda_functions
  lambda_client = Aws::Lambda::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
  lambda_client.list_functions.functions.map(&:function_name)
end

# Retrieves the number of invocations per minute for a specific AWS Lambda function.
#
# @param function_name [String] the name of the AWS Lambda function.
# @param start_time [Time] the start of the time range to retrieve invocations for.
# @param end_time [Time] the end of the time range to retrieve invocations for.
# @return [Float] the number of invocations per minute for the specified function.
def get_lambda_invocations_per_minute(function_name, start_time, end_time)
  cloudwatch_client = Aws::CloudWatch::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
  metric_name = 'Invocations'
  namespace = 'AWS/Lambda'
  dimensions = [{ name: 'FunctionName', value: function_name }]
  statistics = ['Sum']
  period = 60 # 1 minute
  
  resp = cloudwatch_client.get_metric_statistics({
    namespace: namespace,
    metric_name: metric_name,
    dimensions: dimensions,
    start_time: start_time,
    end_time: end_time,
    period: period,
    statistics: statistics,
  })

  resp.datapoints.empty? ? 0 : resp.datapoints.first.sum
end

# Usage

start_time = Time.now - 60 # 1 minute ago
end_time = Time.now

lambda_functions = get_lambda_functions
invocations_per_minute = lambda_functions.map do |function_name|
  get_lambda_invocations_per_minute(function_name, start_time, end_time)
end

invocations_per_minute.sum
