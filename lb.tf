resource "google_compute_region_network_endpoint_group" "this" {
  provider              = google-beta
  project               = var.project_id
  name                  = "cloudrun-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "asia-northeast1"
  cloud_run {
    service = google_cloud_run_v2_service.this.name
  }
}

module "lb-http" {
  source = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"

  project = var.project_id
  name    = "iap-lb"

  managed_ssl_certificate_domains = [var.domain_name]
  ssl                             = true
  https_redirect                  = true

  backends = {
    default = {
      groups = [
        {
          group = google_compute_region_network_endpoint_group.this.id
        }
      ]

      enable_cdn = false

      log_config = {
        enable = false
      }

      iap_config = {
        enable = true
        oauth2_client_id = var.oauth2_client_id
        oauth2_client_secret = var.oauth2_client_secret
      }

    }
  }
}
