
# Question
# what is the name of our most active sns topic over the past 24 hours?

# Methods

require 'aws-sdk-sns'
require 'aws-sdk-cloudwatch'

# Initialize the SNS and CloudWatch clients
sns_client = Aws::SNS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
cloudwatch_client = Aws::CloudWatch::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Retrieves all SNS topics
# @param sns_client [Aws::SNS::Client] an instance of the AWS SNS client
# @return [Array<String>] an array of SNS topic ARNs
def get_all_sns_topics(sns_client)
  sns_client.list_topics.topics.map(&:topic_arn)
end

# Retrieves the number of published messages for a specific SNS topic within a time range
# @param cloudwatch_client [Aws::CloudWatch::Client] an instance of the AWS CloudWatch client
# @param topic_arn [String] the ARN of the SNS topic
# @param start_time [Time] the start of the time range
# @param end_time [Time] the end of the time range
# @return [Integer] the number of published messages for the SNS topic within the time range
def get_published_messages(cloudwatch_client, topic_arn, start_time, end_time)
  metric_name = 'NumberOfMessagesPublished'
  namespace = 'AWS/SNS'
  dimensions = [{ name: 'TopicName', value: topic_arn.split(':').last }]
  datapoints = cloudwatch_client.get_metric_statistics(
    namespace: namespace,
    metric_name: metric_name,
    dimensions: dimensions,
    start_time: start_time,
    end_time: end_time,
    period: 86400, # 24 hours in seconds
    statistics: ['Sum']
  ).datapoints
  datapoints.empty? ? 0 : datapoints.first.sum
end

# Usage

# Get all SNS topics
topics = get_all_sns_topics(sns_client)

# Set the start and end time for the past 24 hours
start_time = Time.now - 86400
end_time = Time.now

# Get the number of published messages for each topic and find the topic with the highest number
most_active_topic = topics.max_by { |topic| get_published_messages(cloudwatch_client, topic, start_time, end_time) }

most_active_topic
