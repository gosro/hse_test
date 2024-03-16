
docker build --platform linux/arm64 -t gosro/hse_distilgpt2:latest . --push

helm install my-clearml allegroai/clearml

helm install distilgpt2 ./distilgpt2-chart
