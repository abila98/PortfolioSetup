# PortfolioSetup

PortfolioSetup is a repository designed to automate infrastructure setup and deployment processes for a portfolio application. It utilizes Packer, Ansible, Terraform, and GitHub Actions to streamline the deployment workflow and ensure scalability.

## Contents

1. **Packer Configuration**: Contains a Packer template to create an Amazon Machine Image (AMI) with necessary configurations and dependencies for the portfolio application.

2. **Ansible Playbooks**: Includes Ansible playbooks to deploy the Docker image created in [PortfolioApp](https://github.com/abila98/PortfolioApp/tree/main) onto the created AMI during the image build process.

3. **Terraform Scripts**: Houses Terraform scripts to define infrastructure components such as VPC requirements, CloudWatch, autoscaling groups, and load balancers. Configures CloudWatch alarms, SNS notifications, and stores the state file in an S3 bucket for centralized management and enables state locking using DynamoDB.

4. **GitHub Actions Workflows**: Contains workflows to automate the CI/CD pipeline, including creating AMIs using Packer, applying Terraform changes, and destroying infrastructure.

## Deployment Instructions

1. Ensure AWS credentials are set up securely as GitHub Secrets.

2. Update the Terraform scripts with the necessary configurations, including the AMI ID created by Packer.

3. Trigger the appropriate GitHub Actions workflows for AMI creation and infrastructure deployment. Once the AMI is created, update the Terraform script with the new AMI ID, and trigger the Terraform workflow to apply changes. Note that applying and destroying infrastructure is a manual workflow action.

4. Monitor CloudWatch alarms and SNS notifications for the number of number of hits your webiste gets.

5. Access the portfolio application by hitting the load balancer URL, typically "http:/<<lb_dns_name>>:8080/portfolio/index.html".

## Contributing

Contributions to PortfolioSetup are welcome! Feel free to open issues for feature requests or bug reports, and submit pull requests for proposed changes.

## License

This project is licensed under the [MIT License](LICENSE).
