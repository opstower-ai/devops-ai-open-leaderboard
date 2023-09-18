
# Question
# how many cloudwatch alarms are in the alarm state?

# Methods

# Fetch all the alarms and filter them by state
# @param cloudwatch_client [Aws::CloudWatch::Client] AWS CloudWatch client initialized with region, access_key_id, and secret_access_key
# @return [Integer] The count of alarms in the 'ALARM' state
def fetch_alarms_in_alarm_state(cloudwatch_client)
  # Describe all alarms
  alarms = cloudwatch_client.describe_alarms
  # Filter alarms that are in 'ALARM' state
  alarms_in_alarm_state = alarms.metric_alarms.select { |alarm| alarm.state_value == 'ALARM' }
  # Return the count of alarms in 'ALARM' state
  alarms_in_alarm_state.count
end

# Usage

# Fetch the count of alarms in the alarm state
fetch_alarms_in_alarm_state(cloudwatch_client)
