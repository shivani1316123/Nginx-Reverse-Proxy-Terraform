Automated Nginx reverse proxy with Terraform.

#have used S3 as well for extracting the Zip folder of webiste files.

Created an S3 bucket -> attached the zip folder in which the index.html file is present.

Launched the EC2 instance (m4.large, key-pair, 25gb more than 16gb)

updated the packages

remove and install the aws cli

then aws configure

Installed Terraform 

Check all installation packages are installed or not using --version command

Transact the shell scripting file in which add the zip file path and unzip the folder and install nginx with python3

create a separate file for main.tf include the provider.tf in same file

in terraform file (add commands to create - default VPC, default ubuntu AMI , default security group SSH, HTTP , HTTPS , key-pair , connecting with the instance command)

then process with terraform exection process the 4's

1. terraform init -- initialize
2. terraform validate -- validate the enteries have been done
3. terraform plan -- to show the process what all implement will happen
4. terraform apply -- execute the files 
