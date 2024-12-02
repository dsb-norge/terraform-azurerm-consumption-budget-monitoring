# Development of module.

Below you can find basic guidelines and rules that must be followed during module development.

## Validate your code

```shell
  # Init project, run fmt and validate
  terraform init -reconfigure
  terraform fmt -check -recursive
  terraform validate

  # Lint with TFLint, calling script from https://github.com/dsb-norge/terraform-tflint-wrappers
  alias lint='curl -s https://raw.githubusercontent.com/dsb-norge/terraform-tflint-wrappers/main/tflint_linux.sh | bash -s --'
  lint

```

### Release

Always use [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) in your pull-requests.  
Module is using [release-please action](https://github.com/googleapis/release-please-action) and that create release PR based on commit when merged to main.  
Use [respective conventional commits](https://github.com/googleapis/release-please?tab=readme-ov-file#how-should-i-write-my-commits) to achieve correct [SemVer](https://semver.org) release number.

Refer to [release-please documentation](https://github.com/googleapis/release-please) for better understanding and when additional questions occur.
