
# Question
# Which deployments have been updated in the past week?

# Methods
#

# Usage
require 'open3'
# This will get all deployments and you'll have to filter by the age manually.
cmd = "kubectl get deployments --all-namespaces"
stdout, stderr, status = Open3.capture3(cmd)
