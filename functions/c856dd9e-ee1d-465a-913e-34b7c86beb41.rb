
# Question
# How often have our ec2 instances been restarted over the past 3 days according to cloudtrail?

# Methods

require 'aws-sdk-cloudtrail'

# Initializes a new instance of the CloudTrail client
#
# @param region [String] AWS region
# @param access_key_id [String] AWS access key ID
# @param secret_access_key [String] AWS secret access key
# @return [Aws::CloudTrail::Client] an instance of the CloudTrail client
def cloudtrail_client(region, access_key_id, secret_access_key)
  Aws::CloudTrail::Client.new(
    region: region,
    access_key_id: access_key_id,
    secret_access_key: secret_access_key
  )
end

# Fetches EC2 restart events from CloudTrail within a specific time range
#
# @param cloudtrail [Aws::CloudTrail::Client] an instance of the CloudTrail client
# @param start_time [Time] the start time of the time range
# @param end_time [Time] the end time of the time range
# @return [Array<Aws::CloudTrail::Types::Event>] an array of EC2 restart events
def get_ec2_restart_events(cloudtrail, start_time, end_time)
  params = {
    start_time: start_time,
    end_time: end_time,
    lookup_attributes: [
      {
        attribute_key: 'EventName',
        attribute_value: 'StartInstances'
      }
    ]
  }

  events = []
  loop do
    response = cloudtrail.lookup_events(params)
    events.concat(response.events)
    break unless response.next_token
    params[:next_token] = response.next_token
  end
  events
end

# Usage

start_time = Time.now - 3*24*60*60 # 3 days ago
end_time = Time.now

cloudtrail = cloudtrail_client(region, access_key_id, secret_access_key)
get_ec2_restart_events(cloudtrail, start_time, end_time)
