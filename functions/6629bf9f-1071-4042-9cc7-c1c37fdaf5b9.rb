
# Question
# Do our ec2 instances have are any unexpected reboots or terminations over the past 7 days?

# Methods

require 'aws-sdk-cloudtrail'

# Fetches the IDs of all EC2 instances.
#
# @param ec2_client [Aws::EC2::Client] An initialized AWS EC2 client.
# @return [Array<String>] An array of EC2 instance IDs.
def fetch_ec2_instance_ids(ec2_client)
  ec2_client.describe_instances.reservations.flat_map do |reservation|
    reservation.instances.map(&:instance_id)
  end
end

# Fetches CloudTrail events for specified EC2 instances within a given time frame.
#
# @param cloudtrail_client [Aws::CloudTrail::Client] An initialized AWS CloudTrail client.
# @param instance_ids [Array<String>] An array of EC2 instance IDs.
# @param start_time [Time] The start of the time frame for fetching events.
# @param end_time [Time] The end of the time frame for fetching events.
# @return [Array<Aws::CloudTrail::Types::Event>] An array of CloudTrail events.
def fetch_cloudtrail_events(cloudtrail_client, instance_ids, start_time, end_time)
  instance_ids.flat_map do |instance_id|
    cloudtrail_client.lookup_events({
      lookup_attributes: [
        {
          attribute_key: "ResourceName",
          attribute_value: instance_id,
        },
      ],
      start_time: start_time,
      end_time: end_time,
    }).events
  end
end

# Filters CloudTrail events for 'StopInstances' or 'TerminateInstances' events.
#
# @param events [Array<Aws::CloudTrail::Types::Event>] An array of CloudTrail events.
# @return [Array<Aws::CloudTrail::Types::Event>] An array of filtered CloudTrail events.
def filter_reboot_termination_events(events)
  events.select do |event|
    ['StopInstances', 'TerminateInstances'].include? event.event_name
  end
end

# Usage

cloudtrail_client = Aws::CloudTrail::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)
start_time = Time.now - 7*24*60*60 # 7 days ago
end_time = Time.now

instance_ids = fetch_ec2_instance_ids(ec2_client)
events = fetch_cloudtrail_events(cloudtrail_client, instance_ids, start_time, end_time)
unexpected_events = filter_reboot_termination_events(events)

unexpected_events
