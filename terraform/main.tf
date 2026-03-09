data "aws_caller_identity" "current" {}

# ── VPC ────────────────────────────────────────────────────────────────────
module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  region      = var.region
  environment = var.environment
  project     = var.project
  account_id  = data.aws_caller_identity.current.account_id
}

# ── Security Groups ────────────────────────────────────────────────────────
module "security_groups" {
  source      = "./modules/security-groups"
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = module.vpc.vpc_cidr_block
  project     = var.project
  environment = var.environment
}

# ── IAM ────────────────────────────────────────────────────────────────────
module "iam" {
  source      = "./modules/iam"
  project     = var.project
  environment = var.environment
  account_id  = data.aws_caller_identity.current.account_id
  region      = var.region

  attachments_bucket_arn       = module.s3.attachments_bucket_arn
  velero_bucket_arn            = module.s3.velero_bucket_arn
  jwt_access_secret_arn        = module.secrets_manager.jwt_access_secret_arn
  jwt_refresh_secret_arn       = module.secrets_manager.jwt_refresh_secret_arn
  redis_password_secret_arn    = module.secrets_manager.redis_password_secret_arn
  rabbitmq_password_secret_arn = module.secrets_manager.rabbitmq_password_secret_arn
  db_secret_arn                = module.rds.db_secret_arn
}

# ── EC2 ────────────────────────────────────────────────────────────────────
module "ec2" {
  source                    = "./modules/ec2"
  project                   = var.project
  environment               = var.environment
  region                    = var.region
  private_subnet_1_id       = module.vpc.private_subnet_1_id
  public_subnet_id          = module.vpc.public_subnet_id
  k8s_nodes_sg_id           = module.security_groups.k8s_nodes_sg_id
  iam_instance_profile_name = module.iam.ec2_instance_profile_name
}

# ── RDS ────────────────────────────────────────────────────────────────────
module "rds" {
  source              = "./modules/rds"
  project             = var.project
  environment         = var.environment
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  rds_sg_id           = module.security_groups.rds_sg_id
}

# ── S3 ─────────────────────────────────────────────────────────────────────
module "s3" {
  source      = "./modules/s3"
  project     = var.project
  environment = var.environment
  account_id  = data.aws_caller_identity.current.account_id
}

# ── ECR ────────────────────────────────────────────────────────────────────
module "ecr" {
  source      = "./modules/ecr"
  project     = var.project
  environment = var.environment
}

# ── Secrets Manager ────────────────────────────────────────────────────────
module "secrets_manager" {
  source      = "./modules/secrets-manager"
  project     = var.project
  environment = var.environment
}

# ── ALB ────────────────────────────────────────────────────────────────────
module "alb" {
  source           = "./modules/alb"
  project          = var.project
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  alb_sg_id        = module.security_groups.alb_sg_id
}

# ── CloudFront ─────────────────────────────────────────────────────────────
module "cloudfront" {
  source       = "./modules/cloudfront"
  project      = var.project
  environment  = var.environment
  alb_dns_name = module.alb.alb_dns_name
}

# ── CloudWatch ─────────────────────────────────────────────────────────────
module "cloudwatch" {
  source         = "./modules/cloudwatch"
  project        = var.project
  environment    = var.environment
  alert_email    = var.alert_email
  alb_arn_suffix = module.alb.alb_arn_suffix
  db_instance_id = module.rds.db_instance_id
  region         = var.region
  account_id     = data.aws_caller_identity.current.account_id
}