
# Question
# Are there any pods that are in a 'Pending' state for more than 10 minutes?

# Methods
#

# Usage
require 'open3'
cmd = "kubectl get pods --all-namespaces | grep Pending"
stdout, stderr, status = Open3.capture3(cmd)
