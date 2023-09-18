
# Question
# how much traffic and errors to each alb over the past 3 hours in requests and errors per-hour

# Methods

# Fetches all Application Load Balancers (ALBs) using the provided Elastic Load Balancing v2 client.
#
# @param elbv2_client [Aws::ElasticLoadBalancingV2::Client] The Elastic Load Balancing v2 client.
# @return [Array<Aws::ElasticLoadBalancingV2::Types::LoadBalancer>] An array of ALBs.
def fetch_all_albs(elbv2_client)
  albs = []
  elbv2_client.describe_load_balancers.each do |response|
    albs += response.load_balancers
  end
  albs
end

# Fetches the traffic and error metrics for a given Application Load Balancer (ALB) within a specified time range.
#
# @param cloudwatch_client [Aws::CloudWatch::Client] The CloudWatch client.
# @param alb [Aws::ElasticLoadBalancingV2::Types::LoadBalancer] The ALB for which to fetch the metrics.
# @param start_time [Time] The start of the time range for which to fetch the metrics.
# @param end_time [Time] The end of the time range for which to fetch the metrics.
# @return [Hash] A hash containing the ALB name, traffic count, and error count.
def fetch_alb_traffic_and_errors(cloudwatch_client, alb, start_time, end_time)
  dimensions = [{ name: 'LoadBalancer', value: alb.load_balancer_name }]
  traffic = cloudwatch_average_over_time('AWS/ApplicationELB', 'RequestCount', dimensions, start_time, end_time)
  errors = cloudwatch_average_over_time('AWS/ApplicationELB', 'HTTPCode_ELB_5XX_Count', dimensions, start_time, end_time)
  { alb: alb.load_balancer_name, traffic: traffic, errors: errors }
end

# Usage

# Initialize the Elastic Load Balancing v2 client
elbv2_client = Aws::ElasticLoadBalancingV2::Client.new(region: region, access_key_id: access_key_id, secret_access_key: secret_access_key)

# Set the start and end times for the past 3 hours
start_time = Time.now - 3 * 60 * 60
end_time = Time.now

# Fetch all the ALBs
albs = fetch_all_albs(elbv2_client)

# Fetch the traffic and errors for each ALB
alb_metrics = albs.map { |alb| fetch_alb_traffic_and_errors(cloudwatch_client, alb, start_time, end_time) }
alb_metrics
