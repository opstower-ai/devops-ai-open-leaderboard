
# Question
# How many pods are currently running in the default namespace?

# Methods
#

# Usage
require 'open3'
cmd="kubectl get pods --namespace=default"
stdout, stderr, status = Open3.capture3(cmd)
stdout+stderr
