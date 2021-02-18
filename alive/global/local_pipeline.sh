#!/usr/bin/env bash

terraform init -reconfigure

if ! terraform fmt -check; then 
    echo "tisk tisk"
    terraform fmt
fi

terraform validate
terraform plan -out=plan
