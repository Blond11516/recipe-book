terraform {
  required_providers {
    fly = {
      source  = "fly-apps/fly"
      version = "0.0.20"
    }
  }

  backend "s3" {
    bucket                      = "recipe-book-tfstate"
    key                         = "recipe-book.tfstate"
    endpoint                    = "https://e8a71681be6b909e3ef859de77d750c8.r2.cloudflarestorage.com"
    region                      = "auto"
    skip_region_validation      = true
    skip_credentials_validation = true
    profile                     = "cloudflare-r2"
  }
}

provider "fly" {
  fly_api_token        = var.fly_token
  useinternaltunnel    = true
  internaltunnelorg    = "etiennel-recipe-book"
  internaltunnelregion = "yul"
}

resource "fly_app" "recipe_book_app" {
  name = "etiennel-recipe-book-machines"
  org  = "etiennel-recipe-book"
}

resource "fly_cert" "recipe_book_cert" {
  app      = fly_app.recipe_book_app.name
  hostname = "recettes.etiennel.dev"
}

resource "fly_ip" "recipe_book_ipv4" {
  app  = fly_app.recipe_book_app.name
  type = "v4"
}

resource "fly_ip" "recipe_book_ipv6" {
  app  = fly_app.recipe_book_app.name
  type = "v6"
}

resource "fly_volume" "recipe_book_sqlite_volume" {
  name   = "sqlite"
  app    = fly_app.recipe_book_app.name
  size   = 3
  region = "yul"
}

resource "fly_machine" "recipe_book_machine" {
  app      = fly_app.recipe_book_app.name
  region   = "yul"
  name     = "etiennel-recipe-book"
  image    = "flyio/iac-tutorial:latest"
  cpus     = 1
  cputype  = "shared"
  memorymb = 512
  env = {
    SECRET_KEY_BASE        = var.secret_key_base
    LIGHTSTEP_ACCESS_TOKEN = var.lightstep_access_token
    PHX_HOST               = "recettes.etiennel.dev"
    PORT                   = "8080"
    DATABASE_PATH          = "/sqlite/recipe-book.sqlite"
  }
  services = [
    {
      ports = [
        {
          port     = 443
          handlers = ["tls", "http"]

        },
        {
          port     = 80
          handlers = ["http"]
        }
      ]
      protocol      = "tcp"
      internal_port = 8080
    }
  ]
  mounts = [
    {
      path   = "/sqlite"
      volume = fly_volume.recipe_book_sqlite_volume.id
    }
  ]
  lifecycle {
    ignore_changes = [
      image
    ]
  }
}

output "machine_id" {
  value = fly_machine.recipe_book_machine.id
}
