# AWS Cloud Portfolio

Welcome to my cloud portfolio repository! Here you will find the Infrastructure as Code (IaC) and the source files for my personal website.

**Live Website:** [https://hubert-dziedzic.pl](https://hubert-dziedzic.pl)

> **Project Status:** This project is **actively under development**! I am continuously adding new features, experimenting with AWS services, and improving the underlying architecture.

## Technologies Used

* **Cloud:** AWS (S3, CloudFront, Route53, ACM, IAM, Lambda, DynamoDB, SNS)
* **Infrastructure as Code:** Terraform
* **Backend / API:** Python (boto3)
* **CI/CD:** GitHub Actions (with OIDC keyless authentication)
* **Frontend:** HTML/CSS/JS (in the `/website` directory)

## Architecture & Deployment

The website is designed as a highly available, fully serverless application. Below is a breakdown of how the components interact:

1. **Frontend Hosting & Security:** Static assets (HTML, CSS, JS) are stored in a private **Amazon S3** bucket. Direct public access to the bucket is blocked, and content is exclusively served through CloudFront using Origin Access Control (OAC).
2. **DNS & Content Delivery:** **Amazon Route 53** routes traffic to the custom domain, while **Amazon CloudFront** acts as a global CDN to cache content at edge locations for low latency. **AWS Certificate Manager (ACM)** handles SSL/TLS certificates to enforce secure HTTPS connections.
3. **Serverless Backend API:** A Python-based **AWS Lambda** function powers the dynamic "Visitor Counter" feature. It is exposed via a lightweight Lambda Function URL (configured with strict CORS rules) to handle frontend HTTP requests efficiently.
4. **Database State:** The visitor count is maintained in an **Amazon DynamoDB** table, providing fast, scalable, and serverless NoSQL storage with Pay-Per-Request billing.
5. **Visitor Notifications:** To keep track of engagement, the Lambda function checks the source IP of incoming requests. If it detects a visitor other than myself, it triggers an **Amazon SNS** topic to send a quick, real-time email notification letting me know someone is currently viewing my resume.
6. **Automated CI/CD Pipeline:** The entire infrastructure and frontend updates are automated using **GitHub Actions**. Upon merging changes to the `main` branch, the workflow securely assumes an IAM role via OpenID Connect (OIDC) to sync updated files to S3 and invalidate the CloudFront cache, ensuring zero downtime.