# Terraform configuration for Firebase Hosting infrastructure
# Manages Firebase sites and Cloudflare DNS records for kattakath.com
terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 7.0"
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

resource "google_firebase_hosting_site" "site" {
  provider = google-beta
  project  = var.google_project_id
  site_id  = "corp-website-cms"
}

# Custom domains for Firebase Hosting
resource "google_firebase_hosting_custom_domain" "root" {
  provider     = google-beta
  project      = var.google_project_id
  site_id      = google_firebase_hosting_site.site.site_id
  custom_domain = "kattakath.com"
  wait_dns_verification = false
}

resource "google_firebase_hosting_custom_domain" "www" {
  provider     = google-beta
  project      = var.google_project_id
  site_id      = google_firebase_hosting_site.site.site_id
  custom_domain = "www.kattakath.com"
  redirect_target = "kattakath.com"
  wait_dns_verification = false
}

resource "cloudflare_record" "root_a" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "A"
  content = "199.36.158.100"
  proxied = false
  comment = "Firebase Hosting"
}

resource "cloudflare_record" "www_cname" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"
  content = "kattakath.com"
  proxied = false
  comment = "Redirect www to root domain"
}

resource "cloudflare_record" "firebase_verification" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "TXT"
  content = "hosting-site=${google_firebase_hosting_site.site.site_id}"
  comment = "Firebase site verification"
}
