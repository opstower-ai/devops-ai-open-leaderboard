
# Question
# Which nodes are currently unschedulable?

# Methods
#

# Usage
require 'open3'
cmd = "kubectl get nodes --field-selector spec.unschedulable=true"
stdout, stderr, status = Open3.capture3(cmd)
