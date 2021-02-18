#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

terraform init -reconfigure >/dev/null 2>&1

if ! terraform fmt -check >/dev/null 2>&1; then 
    echo "tisk tisk"
    terraform fmt >/dev/null 2>&1
fi

terraform validate
terraform plan
