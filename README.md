This application will be exposing an HTTP endpoint which, given an input string, returns the amount of characters appearing at least 2 times in it.

For instance, given the input string 'aliopa', the result will be 1 given that only the letter 'a' is repeated.


---
## Summary
I used AWS apprunner to offload as much as possible to managed service. AWS apprunner looked very promising as it provides all features we need like high performance, availability, scalability, and security. They successfully managed to abstract developers away from infrastructure related topic. I liked it.

App is written in golang, terraform for IaC and Taskfile for build tool.
---
# Solution
## Test locally
You should build in the /app directory and then run executable called sre-kata:
`go build`

Send a PUT request:
`curl -XPUT -d "aaaccccqfgh" localhost:8080`

## Test on AWS
Once you apply terraform code, AWS Apprunner url will be available to you via terraform output:
```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

service_arn = "arn:aws:apprunner:eu-west-1:089959619448:service/sre-kata/19f731e66bb6457296d2e4e596a32a6c"
service_status = "RUNNING"
service_url = "rkhxgr3ign.eu-west-1.awsapprunner.com"


curl -XPUT -d "aaaccccqfgh" https://rkhxgr3ign.eu-west-1.awsapprunner.com
3 times a
4 times c
Text provided: aaaccccqfgh
```

I torn down the apprunner due to billing constraints.


## Terraform
I adopted a module for apprunner and separated cloudservices directory for public image registry and s3 bucket to save tfstate of dev environment.
