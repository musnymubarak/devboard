# DevBoard

Real-time developer task tracking platform built on Kubernetes + AWS.

## Architecture
4-Layer: Terraform (IaC) → AWS (Cloud) → Kubernetes (Platform) → Microservices (App)

## Stack

| Layer | Tool / Service | Purpose |
|---|---|---|
| IaC | Terraform 1.7+ | All AWS infrastructure as code — 12 modules, Checkov-scanned |
| IaC Security | Checkov | Scans Terraform for misconfigs before every apply |
| Cloud | AWS VPC | Isolated private network — 2 public + 2 private subnets, NAT Gateway, VPC Endpoints |
| Cloud | AWS EC2 + ASG | 3-node Kubernetes cluster — 1 control-plane (t3.medium) + 2 workers (t3.small) |
| Cloud | AWS RDS PostgreSQL 16 | Managed database — encrypted, automated backups, enhanced monitoring |
| Cloud | AWS S3 | File attachments + Velero backup storage |
| Cloud | AWS ALB | Public HTTPS entry point — TLS termination, NodePort forwarding |
| Cloud | AWS CloudFront | CDN + DDoS protection — ALB kept private |
| Cloud | AWS Secrets Manager | JWT secrets — IRSA-accessed, never stored in K8s |
| Cloud | AWS CloudWatch | Infrastructure alarms (ALB 5xx, ALB p95, RDS CPU, RDS storage) + SNS |
| Platform | kubeadm 1.29 | Cluster bootstrapped from scratch |
| Platform | Helm 3 | Package manager for all K8s manifests |
| Platform | ArgoCD | GitOps continuous deployment |
| Platform | Argo Rollouts | Blue/green + canary deployments with automated Prometheus rollback |
| Platform | Nginx Ingress | HTTP/WebSocket routing inside the cluster |
| Platform | cert-manager | Automatic TLS certificate management |
| Platform | External Secrets Operator | Syncs AWS Secrets Manager → K8s Secrets via IRSA |
| Platform | Cluster Autoscaler | Scales EC2 worker nodes based on pending pods |
| Platform | Prometheus | Metrics collection for all 8 services |
| Platform | Grafana | RED dashboards + k6 load test visualization |
| Platform | Loki + Promtail | Log aggregation from all pods |
| Platform | Alertmanager | SLO-based alert routing to email |
| Platform | k6 | Load testing — 4 scenarios with Prometheus remote write |
| Platform | Velero | K8s cluster state backup to S3 |
| Platform | Trivy | Container image vulnerability scanning in CI |
| App | Node.js 20 LTS + TypeScript | Runtime for all 8 backend microservices |
| App | Express.js + Prisma | HTTP framework + type-safe ORM |
| App | Next.js 15 (App Router) | SSR frontend |
| App | RabbitMQ 3 | Async event broker |
| App | Redis 7 | Caching, rate limiting, WebSocket pub/sub |
| App | Socket.io 4 | Real-time WebSocket updates |

## Services

| Service | Responsibility |
|---|---|
| api-gateway | Single entry point — auth validation, routing, rate limiting |
| auth-service | JWT authentication, refresh tokens, user identity |
| project-service | Project CRUD, membership, permissions |
| task-service | Task lifecycle, assignments, status transitions |
| notification-service | In-app notifications, CronJob cleanup |
| activity-service | Audit log — every state change recorded |
| realtime-service | WebSocket hub — broadcasts live updates via Redis pub/sub |
| frontend | Next.js 15 SSR — full task board UI |

## Cost

~$22/month at 4 hours/day with stop/start discipline and NAT Gateway lifecycle management.

| Resource | Monthly Cost |
|---|---|
| EC2 (3 nodes × 120 hrs) | ~$10.00 |
| RDS db.t3.micro (120 hrs) | ~$2.04 |
| EBS (all volumes) | ~$2.88 |
| NAT Gateway | ~$5.40 |
| S3, ECR, ALB, CloudWatch, Secrets Manager | ~$5.98 |
| CloudFront | $0.00 (free tier) |
| **Total** | **~$26/month** |

Run `~/devboard-stop.sh` at the end of every session. Delete NAT Gateway when not returning same day.

## Status

| Phase | Description | Status |
|---|---|---|
| Phase 0 | Tool installation, repo initialised | ✅ Complete |
| Phase 1 | Terraform remote state bootstrap (S3 + DynamoDB) | ✅ Complete |
| Phase 2 | All AWS infrastructure written and applied via Terraform | ✅ Complete |
| Phase 3 | Kubernetes cluster bootstrap with kubeadm | 🚧 In Progress |
| Phase 4 | Security — RBAC, NetworkPolicy, PSS, External Secrets | ⬜ Pending |
| Phase 5 | Application — 8 microservices built and containerised | ⬜ Pending |
| Phase 6 | CI/CD — GitHub Actions + ArgoCD GitOps | ⬜ Pending |
| Phase 7 | Observability — Prometheus, Grafana, Loki, Alertmanager | ⬜ Pending |
| Phase 8 | Autoscaling — HPA + Cluster Autoscaler | ⬜ Pending |
| Phase 9 | CloudWatch dashboards and alarms | ⬜ Pending |
| Phase 10 | Blue/Green + Canary deployments via Argo Rollouts | ⬜ Pending |
| Phase 11 | Load testing with k6 | ⬜ Pending |
| Phase 12 | Disaster recovery — chaos tests + runbooks | ⬜ Pending |
| Phase 13 | Backup strategy — Velero + RDS snapshots | ⬜ Pending |

## Repository Structure

```
devboard/
├── terraform/              # 12 Terraform modules — all AWS infrastructure
│   └── modules/
│       ├── vpc/            # VPC, subnets, IGW, NAT, VPC endpoints
│       ├── security-groups/# ALB, K8s nodes, RDS security groups
│       ├── ec2/            # Control plane + worker ASG
│       ├── rds/            # PostgreSQL 16
│       ├── s3/             # Attachments + Velero buckets
│       ├── ecr/            # 8 container registries
│       ├── alb/            # Application Load Balancer
│       ├── cloudfront/     # CDN distribution
│       ├── iam/            # Instance profiles, IRSA roles, GitHub OIDC
│       ├── secrets-manager/# JWT secrets
│       └── cloudwatch/     # Alarms, SNS, log groups
├── services/               # 8 Node.js + TypeScript microservices
├── k8s/                    # Kubernetes manifests
├── helm/devboard/          # Helm chart
├── load-tests/             # k6 scripts
├── .github/workflows/      # CI/CD pipelines
└── docs/                   # ADRs, runbooks, SLOs, DR docs
```

## Key Engineering Decisions

- **kubeadm over EKS** — EKS costs $72/month for the control plane alone. kubeadm teaches every cluster component. Skill transfer to EKS is complete.
- **RDS over StatefulSet PostgreSQL** — Managed backups, automated failover, and point-in-time recovery without operational overhead.
- **CloudFront in front of ALB** — ALB URL never exposed publicly. DDoS absorbed at edge. Static assets cached globally.
- **Argo Rollouts over rolling updates** — Automated Prometheus-based rollback. No human needed for common failure patterns.
- **AWS Secrets Manager + ESO over plain K8s Secrets** — Secrets never stored in etcd. IRSA provides temporary credentials.
