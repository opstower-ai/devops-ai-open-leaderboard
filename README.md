# DevOps AI Assistant Open Leaderboard

This project tracks, ranks, and evaluates DevOps AI Assistants across knowledge domains.

_📅 [Book a time on my calendar](https://calendly.com/derek-haynes) or email derek@opstower.ai to chat about these benchmarks._

## 🏆 Current Leaderboard

### AWS Services ([dataset](datasets/aws_services.csv))

| Name      | Accuracy        | Median Duration (s) | Created At |
|-----------|-----------------|---------------------|------------|
| [OpsTower.ai](https://github.com/opstower-ai/llm-opstower)  | [92%](results/OpsTower-2023-09-17-aws_services.csv) 🏆          | 29                  | 2023-09-17 |
| [ReleaseAI](https://release.ai/) | [72%](results/ReleaseAi-2023-09-17-aws_services.csv)             | 11                  | 2023-09-17 |

### AWS CloudWatch Metrics ([dataset](datasets/aws_cloudwatch_metrics.csv))

| Name      | Accuracy        | Median Duration (s) | Created At |
|-----------|-----------------|---------------------|------------|
| [OpsTower.ai](https://github.com/opstower-ai/llm-opstower)  | [89%](results/OpsTower-2023-09-17-aws_cloudwatch_metrics.csv) 🏆          | 42                  | 2023-09-17 |
| [ReleaseAI](https://release.ai/) | [56%](results/ReleaseAi-2023-09-18-aws_cloudwatch_metrics.csv)             | 20                  | 2023-09-18 |

### AWS Billing ([dataset](datasets/aws_billing.csv))

| Name      | Accuracy        | Median Duration (s) | Created At |
|-----------|-----------------|---------------------|------------|
| [OpsTower.ai](https://github.com/opstower-ai/llm-opstower)  | [91%](results/OpsTower-2023-09-18-aws_billing.csv) 🏆          | 53                  | 2023-09-18 |
| [ReleaseAI](https://release.ai/) | [73%](results/ReleaseAi-2023-09-18-aws_billing.csv)             | 23                  | 2023-09-18 |

### kubectl ([dataset](datasets/kubectl.csv))

| Name      | Accuracy        | Median Duration (s) | Created At |
|-----------|-----------------|---------------------|------------|
| [abhishek-ch/kubectl-GPT](https://github.com/abhishek-ch/Kubectl-GPT) | [83%](results/AbhishekchKubectlGpt-2023-09-19-kubectl.csv) 🏆          | 5                   | 2023-09-19 |
| [devinjeon/kubectl-gpt](https://github.com/devinjeon/kubectl-gpt) | [50%](results/DevinjeonKubectlGpt-2023-09-19-kubectl.csv)             | 1                   | 2023-09-19 |
| [mico](https://github.com/tahtaciburak/mico)        | [17%](results/Mico-2023-09-19-kubectl.csv)             | 1                   | 2023-09-19 |


Metrics:

* `Accuracy`: The percent of questions that the DevOps AI Assistant answered correctly.
* `Median Duration`: The median duration in seconds that it took the DevOps AI Assistant to answer a question.

## What is a DevOps AI Assistant?

A DevOps AI Assistant is an LLM-backed autonomous agent that helps DevOps engineers perform their daily tasks. They connect to external systems like AWS and Kubernetes to perform actions on behalf of the user.

## List of DevOps AI Assistants

Only includes assistants that can be invoked from the command line or via a REST API, are functional, and are available for immediate use (not in private beta).

| Name | Focus | Evaluated? |
| -------- | -------- | -------- |
| [OpsTower.ai](https://github.com/opstower-ai/llm-opstower) | AWS | Yes |
| [ReleaseAI](https://release.ai/) | AWS, Kubectl | Yes |
| [aiac](https://github.com/gofireflyio/aiac) | Terraform, kubectl, AWS | No |
| [KubeCtl-ai](https://github.com/sozercan/kubectl-ai) | Kubernetes manifests | No |
| [aiws](https://github.com/huseyinbabal/aiws) | AWS | No |
| [Terraform AI](https://github.com/jigsaw373/terraform-ai) | Terraform  | No |
| [tfgpt](https://github.com/flavius-dinu/tfgpt) | Terraform | No |
| [cloud copilot](https://github.com/aavetis/cloud-copilot) | Azure | No |
| [mico](https://github.com/tahtaciburak/mico) | kubectl | Yes |
| [kubectl-gpt](https://github.com/devinjeon/kubectl-gpt) | kubectl | Yes |
| [kubectl-GPT](https://github.com/abhishek-ch/Kubectl-GPT) | kubectl | Yes |
| [k8sgpt](https://github.com/k8sgpt-ai/k8sgpt) | Kubernetes | No |

### Submit a DevOps AI Assistant for evaluation

Open a PR and submit a DevOps AI Assistant for automated evaluation. To be evaluated, the agent must meet the following criteria:

1. Can be invoked from the command line or via a REST API.
2. Not in private BETA.

## Question Datasets

See the [datasets/](datasets/) directory for the question datasets. There are 3 columns in each dataset csv file:

1. `question`: The question to ask the DevOps AI Assistant
2. `answer_format`: The expected answer in natural language.
3. `reference_functions`: The reference functions that the DevOps AI Assistant should call to answer the question.

List of datasets:

| Name | Example Question |
| -------- | -------- |
| [aws_cloudwatch_metrics.csv](datasets/aws_cloudwatch_metrics.csv) | Were there any Lambda invocations that lasted over 30 seconds in the last day? |
| [aws_services.csv](datasets/aws_services.csv) | Do our ec2 instances have are any unexpected reboots or terminations over the past 7 days? |
| [aws_billing.csv](datasets/aws_billing.csv) | Which region has the highest AWS expenses for me over the past 3 months? |
| [kubectl.csv](datasets/kubectl.csv) | How many pods are currently running in the default namespace? |

## Evaluation Process

1. Iterate over each question in the dataset and store:
  * the answer from the DevOps AI Assistant
  * the truth answer derived from evaluating the human-evaluated [reference functions](functions/) with a [prompt](prompts/answer_from_saved_methods.rb) to summarize the results into an answer.
2. Iterate over the answer results, using the [dynamic eval prompt](prompts/dynamic_eval.rb) to compare the results of the DevOps AI Assistant to the truth answer. This generates a confidence score and a short explanation for background on the score.
3. Store the results in the [results/](results/) directory.

## A note on dynamic evaluation

A critical component of the evaluation process is the dynamic evaluation. It's not feasible to provide a static answer for most questions as the correct answer is environment-specific. For example, the answer to "What is the average CPU utilization across my EC2 instances?" is not a static answer. It depends on the current state of the EC2 instances.

To solve this, I've stored a set of human-evaluated functions to generate the data that provide correct answers. Then, I use an LLM prompt to generate a natural language answer from the data. This would be a poor evaluation process if the LLM provided an incorrect answer based on the returned data, but I have yet to observe significant errors in the LLM's reasoning of the function output.

Please submit a PR if you believe a reference function is incorrect.

## Contact Info

Reach out derek@opstower.ai if you have general questions about this leaderboard.


