# terraform-aws-ec2-iam-role

Terraform module to create IAM role and instance profile for EC2

The module `will not attach the roles to ec2` 

The policies to be used must already exist in IAM.

The module does not create custom policies, instead uses the policies already created in IAM to attch to the role.

## Prerequisites

Terraform version v0.15.0

AWS API KEY

AWS permissions to create the IAM roles and Instance profiles

## Usage

Below is demonstrated how to setup this module ( this is just an example).

~~~bash
module "ec2-iam-role" {
  source    = "GITLAB path"
  role_name = "test"
  policies  = ["AmazonSSMManagedInstanceCore", "CloudWatchAgentServerPolicy"]
}
~~~

## Explaining the module options:

* `source` =  url path that locates the module in GITLAB
* `role_name`= name to be used , e.g:

    - `test` is the name inputted the outcome will be :
        - test-role-ec2 ( IAM role name)
        - test-profile  (Instance profile)

* `policies` = polices to be attach to the role

## Outputs

The ARN of IAM Role

The ARN Unique ID of IAM Role

The Instance Profile Name

## Expected Outputs

~~~bash
arn = "arn:aws:iam::146550048380:role/test-role-ec2"
profile_name = "test-profile"
unique_id = "AROASEHYQIZ6GIE3MENTS"
~~~

## Important Notes

Tags are commented out in the module because we are still defining what tags to be used.

License
-------

BSD

Author Information
------------------

Rui Purificação (rpurificacao@euronext.com)