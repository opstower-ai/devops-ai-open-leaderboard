
# Question
# Display the events related to the hello-world service.

# Methods
#

# Usage
require 'open3'
cmd = "kubectl describe service hello-world"
stdout, stderr, status = Open3.capture3(cmd)
