# DevOps AI Assistant Open Leaderboard

This project tracks, ranks, and evaluates DevOps AI Assistants across knowledge domains.

## 🏆 Current Leaderboard

| Name      | Dataset File               | Percent Accuracy | Median Duration (s) | Created At |
|-----------|----------------------------|------------------|---------------------|------------|
| OpsTower  | aws_cloudwatch_metrics.csv | 89%              | 42                  | 2023-09-17 |
| ReleaseAi | aws_cloudwatch_metrics.csv | 56%              | 20                  | 2023-09-18 |
| OpsTower  | aws_services.csv           | 92%              | 29                  | 2023-09-17 |
| ReleaseAi | aws_services.csv           | 72%              | 11                  | 2023-09-17 |

Metrics:

* Percent Accuracy: The percent of questions that the DevOps AI Assistant answered correctly.
* Median Duration: The median duration in seconds that it took the DevOps AI Assistant to answer a question.

## Evaluated DevOps AI Assistants

* [OpsTower.ai](https://github.com/opstower-ai/llm-opstower)
* [ReleaseAi](https://release.ai)

## What is a DevOps AI Assistant?

A DevOps AI Assistant is an LLM-backed autonomous agent that helps DevOps engineers perform their daily tasks. They connect to external systems like AWS and Kubernetes to perform actions on behalf of the user.

## Submit a DevOps AI Assistant for evaluation

Open a PR and submit a DevOps AI Assistant for automated evaluation. Automated evaluations that your assistant can be interacted with on the command line or via a REST API.

## Question Datasets

See the [datasets/](datasets/) directory for the question datasets. There are 3 columns in each dataset csv file:

1. `question`: The question to ask the DevOps AI Assistant
2. `answer_format`: The expected answer in natural language.
3. `reference_functions`: The reference functions that the DevOps AI Assistant should call to answer the question.

## Evaluation Process

1. Iterate over each question in the dataset and store:
  * the answer from the DevOps AI Assistant
  * the truth answer derived from evaluating the human-evaluated [reference functions](functions/) with a [prompt](prompts/answer_from_saved_methods.rb) to summarize the results into an answer.
2. Iterate over the answer results, using the [dynamic eval prompt](prompts/dynamic_eval.rb) to compare the results of the DevOps AI Assistant to the truth answer. This generates a confidence score and a short explanation for background on the score.
3. Store the results in the [results/](results/) directory.

A critical component of the evaluation process is the dynamic evaluation. It's not feasible to provide a static answer for most questions as the correct answer is environment-specific. For example, the answer to "What is the average CPU utilization across my EC2 instances?" is not a static answer. It depends on the current state of the EC2 instances. To solve this, I've stored a set of human-evaluated functions to generate the data that provide correct answers. Then, I use an LLM prompt to generate a natural language answer from the data. This would be a poor evaluation process if the LLM provided an incorrect answer based on the returned data, but I have yet to observe significant errors in the LLM's reasoning of the function output.

Please submit a PR if you believe a reference function is incorrect.




