# DevOps AI Assistant Open Leaderboard

This project tracks, ranks, and evaluates DevOps AI Assistants across a number of knowledge domains.

__[🏆 View the current leaderboard](https://docs.google.com/spreadsheets/d/1zR5X5-ad-B2KPqnu5h1Ejh4FCGBb1av2VIN_enYQDl8/edit?usp=sharing).__

## What is a DevOps AI Assistant?

A DevOps AI Assistant is an LLM-backed autonomous agent that helps DevOps engineers perform their daily tasks. They connect to external systems like AWS and Kubernetes to perform actions on behalf of the user.

## Submit a DevOps AI Assistant for evaluation

Open a PR and submit a DevOps AI Assistant for automated evaluation. Automated evaluation requires that your AI assistant has an OpenAI API-compatible endpoint.

## Basic Usage

```
python main.py \
    --model opstower
    --model_url https://app.opstower.ai/api/v1 \
    --api_key [YOUR API KEY] \
    --dataset aws_resources
```

This will generate a `results/aws_resources/opstower_[ISO8601 Date].json` file with the results of the evaluation.
