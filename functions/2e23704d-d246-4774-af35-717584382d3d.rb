
# Question
# List all services exposing port 80

# Methods
#

# Usage
require 'open3'
cmd = "kubectl get services -o wide -n default | grep ':80'"
stdout, stderr, status = Open3.capture3(cmd)
