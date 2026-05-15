module "postgres" {
  source = "git::https://github.com/DarojaAI/terraform-gcp-wrappers.git//modules/postgres-stack?ref=v1.0.0"

  project_id           = var.project_id
  postgres_db_password = var.postgres_db_password
  instance_name        = "rag-research-${var.environment}-pg"
  repo_prefix          = "rag-research"
  environment          = var.environment

  vpc_name    = module.vpc_egress.vpc_name
  subnet_name = module.vpc_egress.subnet_name
  network_id  = module.vpc_egress.vpc_id
  subnet_id   = module.vpc_egress.subnet_id
  subnet_cidr = module.vpc_egress.subnet_cidr

  postgres_version = "15"
  postgres_db_name = "rag_taxonomy"
  postgres_db_user = "app_user"
  machine_type     = "e2-small"
  region           = var.region

  allowed_source_cidrs = [module.vpc_egress.subnet_cidr]
  vpc_connector_cidr   = ""
}
