# AWS Cloud Portfolio

Welcome to my cloud portfolio repository! Here you will find the Infrastructure as Code (IaC) and the source files for my personal website.

**Live Website:** [https://hubert-dziedzic.pl](https://hubert-dziedzic.pl)

> **Project Status:** This project is **actively under development**! I am continuously adding new features, experimenting with AWS services, and improving the underlying architecture.

## Technologies Used

* **Cloud:** AWS (S3, CloudFront, IAM, OIDC)
* **Infrastructure as Code:** Terraform
* **CI/CD:** GitHub Actions
* **Frontend:** HTML/CSS/JS (in the `/website` directory)

## Architecture & Deployment

The website is fully serverless and hosted on AWS.
1. Static files are securely stored in a private **Amazon S3** bucket.
2. Content delivery (CDN), HTTPS encryption, and caching are handled by **Amazon CloudFront**.
3. The entire deployment process (triggered by changes to the `main` branch) is fully automated using **GitHub Actions** with secure, keyless authentication (OpenID Connect).
