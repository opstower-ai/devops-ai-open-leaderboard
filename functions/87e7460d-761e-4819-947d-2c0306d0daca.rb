
# Question
# Are there any billing alerts or notifications set up for my account?

# Methods

# Fetches all the alarms in CloudWatch
# @param cloudwatch_client [Aws::CloudWatch::Client] an instance of Aws::CloudWatch::Client
# @return [Array<String>] an array of alarm names
def fetch_all_alarms(cloudwatch_client)
  cloudwatch_client.describe_alarms.metric_alarms.map(&:alarm_name)
end

# Filters out billing alarms from a list of alarms
# @param cloudwatch_client [Aws::CloudWatch::Client] an instance of Aws::CloudWatch::Client
# @param alarms [Array<String>] an array of alarm names
# @return [Array<String>] an array of billing alarm names
def filter_billing_alarms(cloudwatch_client, alarms)
  alarms.select do |alarm|
    alarm_metric = cloudwatch_client.describe_alarms({alarm_names: [alarm]}).metric_alarms[0]
    alarm_metric.metric_name == 'EstimatedCharges' && alarm_metric.namespace == 'AWS/Billing'
  end
end

# Usage

# Fetch all the alarms
alarms = fetch_all_alarms(cloudwatch_client)

# Filter out the billing alarms and return them
filter_billing_alarms(cloudwatch_client, alarms)
