# Terragrunt / Terraform image

Simple image to handle running Terraform / Terragrunt. Also useful for Terraform pre-commit checks including `tfsec`, `tflint`, and `checkov`.

Uses GitHub Actions to build. Build output can be found [here](https://hub.docker.com/r/so1omon/tf_image).

Builds are triggered by pushing tags to the 'main' branch.
