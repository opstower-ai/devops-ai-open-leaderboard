
# Question
# How many nodes are currently part of the cluster?

# Methods
#

# Usage
require 'open3'
cmd = "kubectl get nodes"
stdout, stderr, status = Open3.capture3(cmd)
