# Azure Secure Image Pipeline (DevSecOps Project)

Building a secure, automated pipeline to produce hardened “Golden Images” in Azure using Infrastructure as Code, CI/CD, and security-first design.

## 🎯 Project Overview

This project focuses on creating a fully automated pipeline that builds, hardens, scans, and distributes secure virtual machine images in Azure.

The goal is simple:
Every server should start from a **known, secure baseline** — no manual configuration, no inconsistencies, no shortcuts.

Instead of relying on manual setup through the Azure Portal, this project uses Infrastructure as Code (IaC) and CI/CD to enforce security, consistency, and repeatability from the start.

---

## 🧠 Core Concepts

- **Infrastructure as Code (IaC)**  
  All Azure resources are defined using Terraform for repeatable and version-controlled deployments.

- **CI/CD Pipeline (GitHub Actions)**  
  Every code push triggers an automated workflow to build and validate infrastructure.

- **Automated Security Hardening**  
  VM images are scanned during build using tools like Lynis to enforce security standards.

- **Cloud Identity & Least Privilege**  
  Managed Identities are used to ensure services only have the permissions they need.

- **Observability by Design**  
  Azure Monitor Agent is injected into images so logging is enabled by default.

---

## 🏗️ Architecture (High-Level)

1. Code is pushed to GitHub  
2. GitHub Actions pipeline is triggered  
3. Terraform provisions Azure resources  
4. Azure VM Image Builder creates a VM image  
5. Security scans are executed (Lynis)  
6. If compliant → image is stored in Azure Compute Gallery  
7. If not → build fails  

---

## 🛠️ Tech Stack

- **Terraform** – Infrastructure as Code  
- **GitHub Actions** – CI/CD Pipeline  
- **Azure VM Image Builder** – Image creation  
- **Azure Compute Gallery** – Image storage and distribution  
- **Azure Managed Identity** – Secure access control  
- **Lynis** – Security auditing and hardening  
- **Azure Monitor Agent** – Logging and observability  

---

## 📂 Project Structure
- **/terraform** # Infrastructure as Code (Azure resources)

- **/scripts** # Hardening and configuration scripts

- **/.github/workflows** # CI/CD pipeline definitions


---

## 🚀 Current Status

- [x] Project initialized  
- [x] Terraform setup  
- [ ] Azure resources fully defined  
- [ ] CI/CD pipeline implemented  
- [ ] Image Builder integration  
- [ ] Security scanning (Lynis)  
- [ ] Observability integration  

---

## 🔐 Security Focus

This project is built with a **security-first mindset**:

- No manual infrastructure changes  
- Automated validation before deployment  
- Security gates to prevent non-compliant builds  
- Least privilege access using Managed Identities  
- Logging enabled by default on all deployed systems  

---

## 📈 Why This Project Matters

Modern cloud environments require:
- Consistency at scale  
- Automated security enforcement  
- Reduced human error  

This project demonstrates the ability to:
- Design secure cloud architecture  
- Implement DevSecOps pipelines  
- Enforce security controls programmatically  

---

## 🧭 What I’m Learning

- Building real-world DevSecOps pipelines  
- Applying security controls in CI/CD workflows  
- Using Terraform to manage cloud infrastructure  
- Designing secure, scalable Azure environments  

---

## 🤝 Contributions

This is a personal learning project, but feedback and suggestions are always welcome.

---

## 📌 Author

Built by a Security Engineer focused on bridging **software development and cybersecurity** to create secure, scalable systems.
