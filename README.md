# Jenkins Pipeline using Vault secrets with Ansible

This project demonstrates how to use Jenkins to retrieve and add secrets from a vault and pass them as extra variables to Ansible. Ansible then deploys to a remote AWS instance and sets up an NGINX web page using the variables provided by Jenkins.

## Prerequisites

1. **Jenkins**:
    - Ensure Jenkins is running, either on a container or a host machine.
    - Install the Ansible plugin for Jenkins.
    - Verify that Jenkins has an SSH key configured for accessing the target machines.

2. **Vault**:
    - Store the required secrets (`NGINX_PORT_SECRET`) or whatever secret you want to use in a secure vault.

3. **AWS Instance**:
    - Ensure the AWS instance is accessible and properly configured for deployment.

4. **Ansible**:
    - Install Ansible on the Jenkins machine or container.

## Usage

1. **Configure Jenkins Pipeline**:
    - Use the provided `Jenkinsfile` to set up a Jenkins pipeline.
    - Ensure the pipeline add to your Vault your secret.
    - Ensure the pipeline retrieves the secrets from the vault and passes them as environment variables.
    - Configure the Jenkins job to include a parameter for the header (`headers_name`) that will be passed to the Ansible playbook.

2. **Run the Ansible Playbook using Jenkins Job**:
    - Use your Jenkins job to execute the pipeline.
    - The Jenkins pipeline will execute the following command:
      ```bash
      ansible-playbook -i inventory.ini playbook.yml \
         --extra-vars "nginx_port=${NGINX_PORT_SECRET} headers_name=${NGINX_HEADERS_SECRET} jenkins_build_number=${JENKINS_BUILD_NUMBER}"
      ```
    - or the folder var option that are presented in th

3. **Deployment**:
    - Ansible will deploy the application to the AWS instance and configure the NGINX web page using the provided variables.
    - update nginx port using vault secret
    - update index.html page header and build number using jenkins parameters.

## Notes

- Ensure the `inventory.ini` file is correctly configured with the AWS instance details.
- The `playbook.yml` file should include tasks to set up NGINX and apply the variables passed from Jenkins.

## Summary

This project integrates Jenkins, Vault, and Ansible to automate the deployment of an NGINX web page on an AWS instance. It demonstrates a seamless CI/CD pipeline with secure secret management that are taking from vault with jenkins and are passing to Ansible.