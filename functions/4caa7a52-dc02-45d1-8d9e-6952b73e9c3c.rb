
# Question
# Are there any services without any endpoints in the hello-world namespace?

# Methods
#

# Usage
require 'open3'
cmd = "kubectl get services -n hello-world | grep '<none>'"
stdout, stderr, status = Open3.capture3(cmd)
