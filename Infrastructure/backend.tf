terraform {
  backend "s3" {
    # Values are passed via -backend-config flags in CI/CD pipeline
    # to avoid hardcoding bucket names and secrets in source code.
    # Required flags: bucket, key, region, dynamodb_table, encrypt
  }
}
