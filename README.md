# Marathon Terraform Provider

[![Build Status](https://travis-ci.org/nicgrayson/terraform-provider-marathon.svg?branch=master)](https://travis-ci.org/nicgrayson/terraform-provider-marathon)

## Install
```
$ go get github.com/nicgrayson/terraform-provider-marathon
```

## Usage

### Provider Configuration
Use a [tfvar file](https://www.terraform.io/intro/getting-started/variables.html) or set the ENV variable

```bash
$ export TF_VAR_marathon_url="http://marthon.domain.tld:8080"
```

```hcl
variable "marathon_url" {}

provider "marathon" {
  url = "${var.marathon_url}"
}
```

If Marathon endpoint requires basic auth (with TLS, hopefully), optionally include username and password:
```bash
$ export TF_VAR_marathon_url="https://marthon.domain.tld:8443"
$ export TF_VAR_marathon_user="username"
$ export TF_VAR_marathon_password="password"

```

```hcl
variable "marathon_url" {}
variable "marathon_user" {}
variable "marathon_password" {}

provider "marathon" {
  url = "${var.marathon_url}"
  basic_auth_user = "${var.marathon_user}"
  basic_auth_password = "${var.marathon_password}"
}
```

To use Marathon from a DCOS cluster you need to get a [token](https://dcos.io/docs/1.8/administration/id-and-access-mgt/iam-api/) and include the [framework path](https://docs.mesosphere.com/1.8/usage/service-guides/marathon/install) in the Marathon URL:

```bash
export TF_VAR_marathon_url="http://dcos.domain.tld/service/marathon"
export TF_VAR_dcos_token="<authentication-token>"
```

```hcl
variable "marathon_url" {}
variable "dcos_token" {}

provider "marathon" {
  url        = "${var.marathon_url}"
  dcos_token = "${var.dcos_token}"
}
```

If you have an additional Marathon instance called *marathon-alice* set *marathon_url* to `http://dcos.domain.tld/service/marathon-alice`. Refer to the *go-marathon* [documentation](https://github.com/gambol99/go-marathon/blob/master/README.md#creating-a-client) to get details about custom paths in Marathon URLs.

### Basic Usage
```hcl
resource "marathon_app" "hello-world" {
  app_id= "/hello-world"
  cmd = "echo 'hello'; sleep 10000"
  cpus = 0.01
  instances = 1
  mem = 16
  ports = [0]
}
```

### Docker Usage
```hcl
resource "marathon_app" "docker-hello-world" {
  app_id = "/docker-hello-world"
  container {
    docker {
      image = "hello-world"
    }
  }
  cpus = 0.01
  instances = 1
  mem = 16
  ports = [0]
}
```

### Full Example

[terraform file](test/example.tf)

## Development

### Build
```bash
$ go install
```

### Test
```bash
$ export MARATHON_URL="http://marthon.domain.tld:8080"
$ ./test.sh
```

### Updating dependencies

This project uses [godep](https://github.com/tools/godep) to manage dependencies. If you're using Golang 1.6+, to build, nothing needs done. Please refer to https://devcenter.heroku.com/articles/go-dependencies-via-godep for help with updating and restoring godeps.
