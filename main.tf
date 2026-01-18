# Terraform configuration for Firebase Hosting infrastructure
# Manages Firebase sites and Cloudflare DNS records for kattakath.com
terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "google-beta" {
  project = var.google_project_id
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "google_firebase_hosting_site" "default_site" {
  provider = google-beta
  project  = var.google_project_id
  site_id  = "corp-core-hub"
}

resource "google_firebase_hosting_site" "site" {
  provider = google-beta
  project  = var.google_project_id
  site_id  = "corp-website"
}

resource "google_firebase_hosting_custom_domain" "custom_domain" {
  provider      = google-beta
  project       = var.google_project_id
  site_id       = google_firebase_hosting_site.site.site_id
  custom_domain = var.domain
}

resource "cloudflare_record" "root_a" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "A"
  content = "199.36.158.100"
  proxied = false
  comment = "Firebase Hosting"
}

resource "cloudflare_record" "firebase_verification" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "TXT"
  content = "hosting-site=${google_firebase_hosting_site.site.site_id}"
  comment = "Firebase site verification"
}
