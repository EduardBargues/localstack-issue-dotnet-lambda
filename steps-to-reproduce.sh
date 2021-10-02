dotnet lambda package -c release --output-location lambda-dotnet.zip
docker-compose up -d localstack
terraform init
terraform apply --auto-approve
aws lambda invoke --function-name lambda-dotnet --endpoint-url=http://localhost:4566 output.txt