resource "google_iap_brand" "project_brand" {
  support_email     = var.support_email
  application_title = "Cloud IAP protected Application"
  project           = var.project_id
}

resource "google_iap_web_backend_service_iam_binding" "this" {
  project = var.project_id
  web_backend_service = module.lb-http.backend_services.default.name
  role = "roles/iap.httpsResourceAccessor"
  members = [
    "user:${var.access_user_email}",
  ]
}
