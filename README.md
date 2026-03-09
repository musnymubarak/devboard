# DevBoard

Real-time developer task tracking platform built on Kubernetes + AWS.

## Architecture
4-Layer: Terraform (IaC) → AWS (Cloud) → Kubernetes (Platform) → Microservices (App)

## Stack
- **IaC**: Terraform — 12 modules, Checkov-scanned
- **Cloud**: AWS VPC, EC2, RDS, S3, ALB, CloudFront, Secrets Manager, CloudWatch
- **Platform**: kubeadm, Helm, ArgoCD, Argo Rollouts, Prometheus, Grafana, Loki, k6, Velero
- **App**: 8 Node.js + TypeScript microservices, Next.js 15 frontend

## Cost
~$22/month at 4 hours/day with stop/start discipline

## Status
🚧 Phase 0 complete — tools installed, repo initialized