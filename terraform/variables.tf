variable "fly_token" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "secret_key_base" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "lightstep_access_token" {
  type      = string
  nullable  = false
  sensitive = true
}
