resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "9.2.3"

  namespace        = "grafana"
  create_namespace = true

  values = [
    yamlencode({
      ingress = {
        enabled          = true
        ingressClassName = "nginx"

        hosts = [
          local.grafana_hostname
        ]
      }

      service = {
        type = "NodePort"
      }

      server = {
        root_url         = "http://${local.grafana_hostname}/"
        serve_from_sub_path = false
      }

      datasources = {
        "datasources.yaml" = {
          apiVersion = 1

          datasources = [
            {
              name       = "Prometheus"
              type       = "prometheus"
              uid        = "PBFA97CFB590B2093"
              access     = "proxy"
              url        = "http://prometheus-server.prometheus.svc.cluster.local"
              isDefault  = true
              editable   = false
            },
            {
              name       = "Tempo"
              type       = "tempo"
              access     = "proxy"
              url        = "http://grafana-tempo.grafana-tempo:3100"
              isDefault  = false
              editable   = false
            }
          ]
        }
      }

      dashboardProviders = {
        "dashboardproviders.yaml" = {
          apiVersion = 1

          providers = [
            {
              name            = "default"
              orgId           = 1
              folder          = ""
              type            = "file"
              disableDeletion = false
              editable        = true

              options = {
                path = "/var/lib/grafana/dashboards/default"
              }
            }
          ]
        }
      }

      dashboards = {
        default = {
          grafana-nginx-dashboard = {
            gnetId     = 315
            revision   = 3
            datasource = "Prometheus"
          }
        }
      }
    })
  ]

  depends_on = [
    helm_release.nginx_ingress
  ]
}