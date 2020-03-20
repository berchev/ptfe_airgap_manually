# ptfe_airgap_manually
## Description
The repo is just an example how to perform TFE version 4 airgap installation with valid certificate into AWS Cloud.

Following immutable infrastructure principles, we will build custom ec2 image with packer, which fullfil all TFE requirements.
[How to build such image](https://github.com/berchev/packer-ec2-bionic64-docker)

We will use Terraform OSS and AWS to prepare an environment needed for TFE Airgap instalation.

The Airgap installation steps will be performed manually.

More details about the AWS environment itself, can be found into **Environment diagram** section down below

## Environment diagram
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/diagram.png)

## Repo Content
| File                   | Description                      |
|         ---            |                ---               |
| [aws_ptfe_role.tf](aws_ptfe_role.tf) | Creating an aws role for our instance. |
| [dns_record.tf](dns_record.tf) | Creating DNS record using the IP of newly created instance|
|[outputs.tf](outputs.tf)| After terraform finish its work, will prin on the screen everything that user need to know about newly created environment|
|[postgres.tf](postgres.tf)| Terraform code for PostgeSQL database|
|[ptfe_instance.tf](ptfe_instance.tf)| Terraform code for our TFE instance |
|[security_groups.tf](security_groups.tf)| Terraform code related to security groups of TFE instance and PostgreSQL |
|[variables_and_provider.tf](variables_and_provider.tf)| All variables in this project. Please review and edit if needed |
|[vpc.tf](vpc.tf)| Terraform code related to the whole network infrastructure |
|[bucket.tf](bucket.tf)| Terraform code related to PTFE instance bucket creation |


## Pre-requirements for this project
- Valid SSL sertificate 
- TFE license (you can get one reaching Hashicorp Sales Team)
- Airgap package with desired TFE version
- [Installer bootstraper](https://install.terraform.io/airgap/latest.tar.gz)
- Packer installed

## Requirements
- AWS Account
- Terraform OSS installed
- Your own Domain (I am using one from AWS)

## How to install TFE Airgap 
- make sure you have succesfully builded AWS ami, according to the description in the beginning
- clone the repo locally
```
git clone https://github.com/berchev/ptfe_airgap_manually.git
```

- review [variables_and_provider.tf](variables_and_provider.tf) and change variables value according to your needs. 
- export your AWS access and secret key 
```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
``` 
- install all needed Terraform providers
```
terraform init
```
- check which resources terraform is going to create
```
terraform plan
```
- if no errors occurs, and you are satisfied with the result, apply the changes
```
terraform apply
```
- once terraform finish, you will see an output very similar to this one:
```
postgres_hostname = terraform-20200317132059697800000001.coldp6eoybn0.us-east-1.rds.amazonaws.com:5432
postgres_name = PostgresGeorgiman
ptfe_instance_private_dns = ip-172-0-3-192.ec2.internal
ptfe_instance_private_ip = 172.0.3.192
ptfe_instance_public_dns = ec2-54-174-170-9.compute-1.amazonaws.com
ptfe_instance_public_ip = 54.174.170.9
```
- shh to newly created TFE instance (replace with your `ptfe_instance_public_dns`)
```
ssh -i "/PATH/TO_YOUR/key_pair.pem" ubuntu@ec2-54-174-170-9.compute-1.amazonaws.com
```

- Change to /opt/tfe-installer/ directory
```
cd /opt/tfe-installer/
```

- Run TFE installer script
```
sudo bash install.sh airgap
```

- Enter 0 into the interractive installer, and wait the installer to finish
```
ubuntu@ip-172-0-3-192:/opt/tfe-installer$ sudo bash install.sh airgap
Determining local address
The installer was unable to automatically detect the private IP address of this machine.
Please choose one of the following network interfaces:
[0] ens5        172.0.3.192
[1] docker0     172.17.0.1
Enter desired number (0-1): 0
The installer will use network interface 'ens5' (with IP address '172.0.3.192').

Running preflight checks...
```
- if installer finish successfully, you will see output similar to this one:
```
To continue the installation, visit the following URL in your browser:

  http://<this_server_address>:8800

ubuntu@ip-172-0-3-192:/opt/tfe-installer$
```
- Enter the public address and port 8800 of TFE instance to the browser, like this: `http://54.174.170.9:8800` and click `Continue to setup`
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/1.png)

- Click `Advanced`
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/2.png)

- Click `Proceed to 54.174.170.9 (unsafe)`
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/3.png)

- Type your domain, attach your private and fullchain sertificate and click `Upload and continue`
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/4.png)

- Upload your TFE license file.
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/5.png)

- On the next screen select `Airgapped` and click `Continue`
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/6.png)

- Provide the path to TFE Airgap package: `/opt/tfe-installer/Terraform_Enterprise_408.airgap` and click `Continue`
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/7.png)

- Airgap installation will start
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/8.png)

- Enter password, confirm the password and click on `Continue`
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/9.png)

- After the checks ar completed, click on `Continue`
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/10.png)

- Next screen is for settings. Please do following:
  - click on `check DNS`
 ![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/11.png)
 
  - enter encryption password
  ![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/12.png)
  
  - For `Installation Type` choose `Production`
  ![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/13.png)
  
  - For `Production Type` choose `External Services`
  ![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/14.png)
  
  - Into `PostgreSQL Configuration` section add database username, password, hostname (check terraform output for that), database name (check terraform output for that)
  ![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/15.png)
  
  - From `Object Storage` section set s3, `Use Instance Profile for Access`, bucket and region
  ![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/16.png)
  
  - Into `SSL/TLS Configuration` section add your fullchain.pem content and select `TLS version 1.2 and 1.3` radio button
  ![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/17.png)
  
  - Scroll to the bottom of the page and click `Save`, then `Restart Now`
  ![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/18.png)
  
- Wait until the starting process finish
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/19.png)

- If you see this, your TFE instance is ready
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/20.png)

- Final step is to test it. Type in browser your TFE instance FQDN
![](https://github.com/berchev/ptfe_airgap_manually/blob/master/screenshots/21.png)
