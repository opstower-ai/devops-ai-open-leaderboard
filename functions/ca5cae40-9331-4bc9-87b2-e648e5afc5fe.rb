
# Question
# List all jobs that have completed successfully in the last 24 hours.

# Methods
#

# Usage
require 'open3'
cmd = "kubectl get jobs --field-selector=status.successful=1 --all-namespaces"
stdout, stderr, status = Open3.capture3(cmd)
