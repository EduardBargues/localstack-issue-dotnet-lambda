resource "aws_s3_bucket" "main" {
  bucket = "main"
  acl    = "private"
}
resource "aws_iam_role" "main" {
  name = "main"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_s3_bucket_object" "dotnet" {
  bucket = aws_s3_bucket.main.id
  key    = "lambda-dotnet.zip"
  source = "./lambda-dotnet.zip"
}
resource "aws_lambda_function" "dotnet" {
  s3_bucket     = aws_s3_bucket.main.id
  s3_key        = aws_s3_bucket_object.dotnet.key
  function_name = "lambda-dotnet"
  role          = aws_iam_role.main.arn
  handler       = "Function::Function.Function::FunctionHandler"
  runtime       = "dotnetcore3.1"
  memory_size   = 256
  timeout       = 30
  depends_on = [
    aws_s3_bucket_object.dotnet
  ]

}
