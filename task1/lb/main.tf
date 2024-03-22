resource "google_compute_backend_service" "backend_service" {
  name                  = "backend-service"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"
  health_checks         = [google_compute_health_check.default.self_link]

  backend {
    group = google_compute_instance_group.mig.self_link
  }

  timeout_sec = 10
}

resource "google_compute_health_check" "default" {
  name               = "health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  tcp_health_check {
    port = 80
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  port_range = "80"
}

output "lb_ip" {
  value = google_compute_global_forwarding_rule.forwarding_rule.ip_address
}
