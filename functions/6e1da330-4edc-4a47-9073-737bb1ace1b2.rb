
# Question
# what is the name of our most active sns topic?

# Methods

require 'aws-sdk-sns'
require 'aws-sdk-cloudwatch'

# Initialize the SNS client
sns_client = Aws::SNS::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Initialize the CloudWatch client
cloudwatch_client = Aws::CloudWatch::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Fetches all SNS topics.
# @param sns_client [Aws::SNS::Client] an instance of Aws::SNS::Client.
# @return [Array<String>] an array of SNS topic ARNs.
def fetch_all_sns_topics(sns_client)
  sns_client.list_topics.topics.map(&:topic_arn)
end

# Fetches the number of messages published for a specific SNS topic.
# @param cloudwatch_client [Aws::CloudWatch::Client] an instance of Aws::CloudWatch::Client.
# @param topic_arn [String] the ARN of the SNS topic.
# @param start_time [Time] the start time for the period to fetch the number of messages.
# @param end_time [Time] the end time for the period to fetch the number of messages.
# @return [Integer] the number of messages published for the specific SNS topic.
def fetch_number_of_messages_published(cloudwatch_client, topic_arn, start_time, end_time)
  cloudwatch_average_over_time('AWS/SNS', 'NumberOfMessagesPublished', [{ name: 'TopicName', value: topic_arn.split(':').last }], start_time, end_time)
end

# Finds the most active SNS topic.
# @param sns_client [Aws::SNS::Client] an instance of Aws::SNS::Client.
# @param cloudwatch_client [Aws::CloudWatch::Client] an instance of Aws::CloudWatch::Client.
# @param start_time [Time] the start time for the period to find the most active SNS topic.
# @param end_time [Time] the end time for the period to find the most active SNS topic.
# @return [String] the ARN of the most active SNS topic.
def find_most_active_sns_topic(sns_client, cloudwatch_client, start_time, end_time)
  most_active_topic = nil
  highest_message_count = 0

  fetch_all_sns_topics(sns_client).each do |topic_arn|
    message_count = fetch_number_of_messages_published(cloudwatch_client, topic_arn, start_time, end_time)
    if message_count > highest_message_count
      most_active_topic = topic_arn
      highest_message_count = message_count
    end
  end

  most_active_topic
end

# Usage

# Set the start and end time for this month
start_time = Time.now.beginning_of_month
end_time = Time.now.end_of_month

# Find the most active SNS topic
find_most_active_sns_topic(sns_client, cloudwatch_client, start_time, end_time)
