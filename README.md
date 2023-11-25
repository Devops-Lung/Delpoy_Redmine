# Delpoy Redmine Using Terrafrom and Ansible 
This repository contains the code to deploy Redmine using Terraform and Ansible.
## Authors
 - Class: 20TXTH02 
 - Teacher: JD. Phuc Huynh Le Duy 
 - Member : 
   1. Lung Ho Nhu      - 2010060048 
   2. Khai Huynh Quang - 20100600
   3. Quang Pham Van   - 20100600
   4. Tri Le Cao       - 20100600

## Prerequisites
- Terraform
- Ansible
- Docker
- Git
- Alibaba Cloud
## Docker Presentation
Mr. Tri will present it.
## I. Install Terraform
###   1. Install in linux OS 
Code:
 ~~~bash
 sudo apt update 
 sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
 ~~~
Create Wget:
 ~~~bash
 wget -O- https://apt.releases.hashicorp.com/gpg | \
 gpg --dearmor | \
 sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
 ~~~

Verify the key's fingers:
 ~~~bash
 gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
 ~~~
Add Hashicorp in System.
~~~bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
~~~
Install Terraform:
~~~bash
sudo apt-get update && sudo apt-get install terraform
~~~
### 2. Install Ansible 
    - Ansible use for Deployment by code
    


