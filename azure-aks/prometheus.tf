resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "27.8.0"

  namespace        = "prometheus"
  create_namespace = true

  values = [
    yamlencode({
      extraScrapeConfigs = <<-EOT
        - job_name: 'otel-collector'
          static_configs:
            - targets: ['opentelemetry-collector.opentelemetry:8889']
      EOT

      server = {
        persistentVolume = {
          enabled = false
          size    = "10Gi"
        }

        service = {
          type = "NodePort"
        }
      }

      alertmanager = {
        enabled = false
      }

      pushgateway = {
        enabled = false
      }

      ingress = {
        enabled          = false
        ingressClassName = "nginx"
        annotations      = {}
        labels           = {}
        path             = "/"
        pathType         = "Prefix"
        hosts = [
          "prometheus.local"
        ]
      }
    })
  ]

  depends_on = [
    helm_release.opentelemetry_collector
  ]
}