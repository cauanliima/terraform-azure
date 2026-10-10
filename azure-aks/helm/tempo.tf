resource "helm_release" "grafana_tempo" {
  name       = "grafana-tempo"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "tempo"
  version    = "1.21.0"

  namespace        = "grafana-tempo"
  create_namespace = true
}