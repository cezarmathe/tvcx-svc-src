# tvcx-svc-src - variables

### nomad variables ###

variable "nomad_address" {
  type = string
  description = "Nomad address"
}

variable "nomad_region" {
  type = string
  description = "Nomad region"
}

variable "nomad_token" {
  type = string
  description = "Nomad token"
}

### gitea variables ###

# variable "gitea_version" {
#   type = string
#   description = "The version of the Gitea docker container"
# }

# variable "gitea_ssh_port" {
#   type = number
#   description = "SSH port for the Gitea container"
# }
