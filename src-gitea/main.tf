# src-gitea

# Configure the Nomad provider
provider "nomad" {
  address   = var.nomad_address
  region    = var.nomad_region
  secret_id = var.nomad_token
}

resource "nomad_job" "gitea" {
  jobspec = file("${path.module}/gitea.hcl")
}
