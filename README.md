# Azure Secure Image Pipeline (DevSecOps Project)

Building a secure, automated pipeline to produce hardened “Golden Images” in Azure using Infrastructure as Code, CI/CD, and security-first design.

## Project Overview

This project focuses on building a secure and repeatable infrastructure pipeline for creating hardened Azure virtual machine images using Terraform, GitHub Actions, Azure VM Image Builder, and automated security validation.

The core idea behind this project was:

> Every server should begin from a known, secure, validated baseline.

Instead of manually configuring infrastructure through the Azure Portal, this project uses Infrastructure as Code (IaC), automated validation, policy enforcement, and CI/CD workflows to create secure infrastructure consistently and at scale.

### This project evolved beyond simply learning Terraform syntax. The primary focus became understanding

- How secure cloud infrastructure is automated
- How CI/CD pipelines interact with cloud providers
- How policy enforcement can be embedded directly into infrastructure workflows
- How identity, permissions, and deployment approvals work in real-world cloud environments
- How observability and operational visibility fit into infrastructure automation

---

## Problems This Project Aims to Solve

Traditional infrastructure deployment often introduces several operational and security problems:

- Manual configuration drift
- Inconsistent server baselines
- Forgotten hardening steps
- Weak auditing and traceability
- Overly permissive cloud identities
- Security checks happening too late in the deployment lifecycle
- Infrastructure changes without review or approval

### This project addresses those challenges by introducing

- Infrastructure as Code for repeatable deployments
- CI/CD validation workflows
- Automated security scanning with Lynis
- Security gates that block non-compliant images
- Managed Identity and RBAC-based least privilege access
- GitHub OIDC federation instead of long-lived cloud secrets
- Approval-gated production deployments
- Centralized observability foundations using Azure Log Analytics

---

## High-Level Workflow (Mental Model)

This project follows the workflow below:

```text
Developer writes Terraform code
            ↓
Code is pushed to GitHub
            ↓
GitHub Actions workflow starts automatically
            ↓
Terraform formatting and validation checks run
            ↓
GitHub authenticates securely to Azure using OIDC federation
            ↓
Terraform plan runs against Azure infrastructure
            ↓
Manual approval gate is required before deployment
            ↓
Terraform apply deploys infrastructure into Azure
            ↓
Azure VM Image Builder creates a hardened VM image
            ↓
Lynis security scans execute during image creation
            ↓
Hardening score is evaluated against policy threshold
            ↓
Compliant image is published to Azure Compute Gallery
            ↓
Non-compliant image build fails automatically
```

---

## Policy Enforcement

This pipeline includes automated security enforcement using Lynis hardening scores.

During image creation:

1. Lynis performs a system audit
2. The hardening score is extracted programmatically
3. The pipeline compares the score against a minimum threshold
4. Non-compliant images are blocked from publication

This transforms the image pipeline from passive scanning into an active DevSecOps security gate.

---

## Tech Stack

- Terraform — Infrastructure as Code
- GitHub Actions — CI/CD Automation
- Azure VM Image Builder — Image creation pipeline
- Azure Compute Gallery — Image storage and distribution
- Azure Managed Identity — Secure access control
- Azure RBAC — Least privilege authorization
- GitHub OIDC Federation — Secretless Azure authentication
- Lynis — Security auditing and hardening validation
- Azure Log Analytics Workspace — Observability foundation
- AzAPI Provider — Azure resource management for Image Builder templates

---

## Real-World Applications

This architecture reflects patterns used by:

- Platform Engineering teams
- DevSecOps teams
- Cloud Infrastructure teams
- Security Engineering teams
- Enterprise cloud operations teams

Common real-world use cases include:

- Building hardened server baselines
- Standardizing cloud infrastructure deployments
- Creating approved workstation/server images
- Automating compliance validation
- Enforcing infrastructure policy-as-code
- Reducing manual deployment risk
- Enabling repeatable disaster recovery environments

This project demonstrates concepts commonly used in:

- Financial institutions
- Healthcare environments
- Government and defense systems
- Enterprise cloud platforms
- Security-focused engineering organizations

---

## AI-Assisted Development Workflow

This project was AI-assisted, but not in the sense of blindly generating infrastructure.

AI primarily acted as:

- An interactive rubber duck
- A troubleshooting assistant
- A conceptual walkthrough partner
- A workflow validator
- A documentation and research accelerator

The value of AI in this workflow was not replacing engineering decisions, but accelerating:

- Debugging
- Documentation lookup
- Terraform troubleshooting
- Azure RBAC troubleshooting
- CI/CD pipeline iteration
- Architectural understanding
- Mental model development

This project also demonstrates a real-world example of:

> AI-enhanced engineering workflows.

Modern engineers increasingly use AI as an interactive collaborator to:

- Reduce iteration time
- Accelerate troubleshooting
- Validate architectural decisions
- Improve learning speed
- Explore unfamiliar systems faster

while still maintaining ownership over implementation and engineering decisions.

---

## Project Structure

```text
.
├── .github/
│   └── workflows/
│       ├── terraform-ci.yml
│       └── terraform-plan.yml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── provider.tf
├── scripts/
├── README.md
└── .gitignore
```

---

## CI/CD Pipeline Overview

### CI Workflow

Every push automatically triggers:

- `terraform fmt`
- `terraform validate`
- Terraform initialization checks

This ensures infrastructure consistency before deployment.

### CD Workflow

The CD workflow:

1. Authenticates GitHub Actions to Azure using OIDC federation
2. Runs `terraform plan`
3. Waits for manual approval using GitHub Environments
4. Executes `terraform apply`

This creates a secure deployment pipeline without storing long-lived Azure credentials in GitHub.

---

## Security Focus

This project was built with a security-first mindset.

Implemented security concepts include:

- Least privilege RBAC
- Managed Identity usage
- Secretless OIDC authentication
- Approval-gated deployments
- Automated hardening validation
- Policy-based image publishing
- Immutable infrastructure concepts
- Infrastructure version control
- Automated deployment validation

---

## Key Engineering Lessons Learned

Throughout this project I learned:

- Terraform operates as a dependency graph, not sequential scripting
- Azure Image Builder creates temporary orchestration resources during builds
- CI/CD pipelines require non-interactive configuration handling
- Federated identity changes based on GitHub branch vs environment scopes
- Infrastructure providers evolve quickly and documentation matters
- RBAC troubleshooting is a major part of cloud engineering
- Security scanners require careful exit code handling inside automation
- Infrastructure automation requires defensive debugging and observability
- GitHub Actions runners are ephemeral execution environments
- Cloud automation is heavily API-driven under the hood

---

## How to Run Locally

### Prerequisites

- Azure subscription
- Azure CLI installed
- Terraform installed
- Git installed

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/azure-secure-image-pipeline.git
cd azure-secure-image-pipeline/terraform
```

### 2. Authenticate to Azure

```bash
az login
az account set --subscription "<your-subscription-id>"
```

### 3. Configure Variables

Update `terraform.tfvars`:

```hcl
resource_group_name = "<RESOURCE_GROUP_NAME>"
location            = "<LOCATION>"

tags = {
  Project     = "<PROJECT_NAME>"
  Environment = "<ENVIRONMENT>"
}
```

### 4. Deploy Infrastructure

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Approve with:

```text
yes
```

### 5. Trigger Image Build

```bash
az resource invoke-action \
  --resource-group rg-secure-image-lab \
  --resource-type Microsoft.VirtualMachineImages/imageTemplates \
  --name imgbuilder-secure-ubuntu \
  --action Run
```

### 6. Monitor Build Status

```bash
az resource show \
  --resource-group rg-secure-image-lab \
  --resource-type Microsoft.VirtualMachineImages/imageTemplates \
  --name imgbuilder-secure-ubuntu \
  --query "properties.lastRunStatus"
```

### 7. Verify Published Image Version

```bash
az sig image-version list \
  --resource-group rg-secure-image-lab \
  --gallery-name sigsecureimagelab \
  --gallery-image-definition ubuntu-hardened \
  --output table
```

---

## How to Tear Down Infrastructure

### 1. Delete Image Versions First

Azure Compute Gallery image versions are nested resources and may block Terraform destroy.

```bash
az sig image-version delete \
  --resource-group rg-secure-image-lab \
  --gallery-name sigsecureimagelab \
  --gallery-image-definition ubuntu-hardened \
  --gallery-image-version 1.0.0
```

### 2. Destroy Terraform Infrastructure

```bash
terraform destroy
```

Approve with:

```text
yes
```

### 3. Verify Cleanup

```bash
az group exists --name rg-secure-image-lab
```

Expected result:

```text
false
```

### 4. Check for Temporary Image Builder Resource Groups

```bash
az group list \
  --query "[?contains(name, 'IT_rg-secure-image-lab')].name" \
  --output table
```

If any remain:

```bash
az group delete --name "<staging-resource-group-name>" --yes --no-wait
```

---

## Cost Awareness

This project can incur Azure costs when:

- Azure VM Image Builder creates temporary build resources
- Image versions are stored in Azure Compute Gallery
- Log Analytics retains data
- Temporary orchestration resources remain after failed builds

Always destroy infrastructure after testing.

---

## Future Enhancements

Planned future improvements include:

- Subscription-level Activity Log diagnostic settings
- Centralized log ingestion for Packer customization logs
- Terraform remote state backend
- Multi-environment deployments (Dev/Test/Prod)
- Additional hardening scripts
- CIS benchmark enforcement
- Automated image versioning
- Slack/Teams deployment notifications
- Security dashboard integrations
- Azure Policy integration
- Automated vulnerability reporting
- Full GitHub Actions deployment artifact storage

---

## Contribution Guidelines

This is primarily a personal learning and portfolio project, but feedback and suggestions are welcome.

Contributions should:

- Improve security posture
- Improve deployment reliability
- Improve Terraform structure and maintainability
- Improve observability and troubleshooting
- Maintain least privilege principles
- Avoid introducing hardcoded secrets or credentials

Suggested workflow:

1. Fork repository
2. Create feature branch
3. Submit pull request
4. Include clear explanation of changes

---

## Author

Built by a security-focused engineer with a background in software development, IT Ops, and cybersecurity, focused on bridging DevOps and cybersecurity through secure automation.
