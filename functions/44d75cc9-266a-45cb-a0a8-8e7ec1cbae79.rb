
# Question
# Show me the resource limits for all deployments.

# Methods
#

# Usage
require 'open3'

cmd = "kubectl get deployments --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace} {.metadata.name}\n{.spec.template.spec.containers[*].resources.limits}\n\n{end}'"
stdout, stderr, status = Open3.capture3(cmd)
