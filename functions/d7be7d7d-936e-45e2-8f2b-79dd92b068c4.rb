
# Question
# retrieve all logs over the past 24 hours from the first pod

# Methods
#

# Usage
require 'open3'
cmd = "FIRST_POD=$(kubectl get pods --no-headers -o custom-columns=':metadata.name' | head -1);kubectl logs $FIRST_POD --since=24h"
stdout, stderr, status = Open3.capture3(cmd)
