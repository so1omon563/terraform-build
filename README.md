# Testing image for Terraform

Simple image to handle running Terraform. Also useful for pre-commit checks including `tfsec`, `tflint`, `checkov`, and Inspec using `kitchen-terraform`.

Uses GitHub Actions to build. Build output can be found [here](https://hub.docker.com/r/so1omon/tf_testing).

Builds are triggered by pushing tags to the 'main' branch.
