
# Question
# list all pods

# Methods
#

# Usage
require 'open3'
cmd="kubectl get pods"
stdout, stderr, status = Open3.capture3(cmd)
stdout+stderr
