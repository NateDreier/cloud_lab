# Cloud Lab

IaC, Pipeline concept and brief architecture description

## Architecture

Below is the architecture diagram for the Cloud lab.

![my pic](https://github.com/NateDreier/cloud_lab/blob/main/cloud_lab_architecture-0216.PNG)

## IaC

You will typically find the below files in each directory below:
```
main.tf
variables.tf
outputs.tf
providers.tf
```

```
alive/
├── global
│   ├── backend.tf
│   ├── iam.tf
│   ├── local_pipeline.sh
│   ├── networks.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── s3.tf
│   ├── security_groups.tf
│   └── variables.tf
├── mgmt
│   ├── services
│   └── vpc
├── prod
│   ├── services
│   └── vpc
└── stage
    ├── data-storage
    ├── services
    └── vpc

modules/
│   ├── networking
│   │   ├── security_groups
│   │   ├── subnets_eastandwest
│   │   └── subnets_west
│   └── services
│       └── rocketchat
```

## Pipeline

- Validate - Branch
  - `terraform fmt -check`
  - `terraform validate`
- PR/MR
  - `terraform plan -out=$file`
  - carve up `terraform plan` with jq/sed, save as var
  - create PR/MR
  - POST var to PR/MR
- Merge to Main
  - `terraform apply -auto-approve`