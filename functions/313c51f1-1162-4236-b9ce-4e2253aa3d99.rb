
# Question
# Were there any Lambda invocations that lasted over 30 seconds in the last day?

# Methods

# Fetches all AWS Lambda functions.
# @return [Array<String>] an array of function names.
def fetch_lambda_functions
  lambda_client = Aws::Lambda::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
  lambda_client.list_functions.functions.map(&:function_name)
end

# Checks if a Lambda function has invocations that lasted over 30 seconds in the last day.
# @param function_name [String] the name of the Lambda function.
# @return [Boolean] returns true if the average duration of invocations is over 30 seconds, false otherwise.
def lambda_invocations_over_30_seconds(function_name)
  start_time = Time.now - 86400 # 24 hours ago
  end_time = Time.now

  # Fetch the average duration of invocations for the function in the last day
  average_duration = cloudwatch_average_over_time('AWS/Lambda', 'Duration', [{ name: 'FunctionName', value: function_name }], start_time, end_time)

  # If the average duration is over 30 seconds (30000 milliseconds), return true
  average_duration > 30000
end

# Usage

# Fetch all lambda functions
lambda_functions = fetch_lambda_functions

# Check each function for invocations over 30 seconds in the last day
lambda_functions.select { |function_name| lambda_invocations_over_30_seconds(function_name) }
