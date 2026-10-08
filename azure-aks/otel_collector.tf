resource "helm_release" "opentelemetry_collector" {
  name       = "opentelemetry-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "0.126.0"

  namespace        = "opentelemetry"
  create_namespace = true

  values = [
    yamlencode({
      mode = "statefulset"

      image = {
        repository = "otel/opentelemetry-collector-contrib"
      }

      config = {
        exporters = {
          debug = {}

          prometheus = {
            endpoint = "0.0.0.0:8889"
          }

          "otlphttp/tempo" = {
            endpoint = "http://grafana-tempo.grafana-tempo:4318"
          }

          "otlphttp/coroot" = {
            endpoint = "http://coroot.coroot:8080"
            encoding = "proto"

            headers = {
              "x-api-key" = ""
            }
          }
        }

        extensions = {
          health_check = {
            endpoint = "$${env:MY_POD_IP}:13133"
          }
        }

        processors = {
          batch = {}

          memory_limiter = {
            check_interval         = "5s"
            limit_percentage       = 80
            spike_limit_percentage = 25
          }
        }

        connectors = {
          spanmetrics = {
            histogram = {
              explicit = {
                buckets = [
                  "100us",
                  "1ms",
                  "2ms",
                  "6ms",
                  "10ms",
                  "100ms",
                  "250ms"
                ]
              }
            }

            dimensions = [
              {
                name = "http.method"
              },
              {
                name = "http.status_code"
              },
              {
                name = "http.route"
              }
            ]

            exemplars = {
              enabled = true
            }

            dimensions_cache_size = 1000

            aggregation_temporality = "AGGREGATION_TEMPORALITY_CUMULATIVE"

            metrics_flush_interval = "15s"
            metrics_expiration     = "5m"

            events = {
              enabled = true

              dimensions = [
                {
                  name = "exception.type"
                },
                {
                  name = "exception.message"
                }
              ]
            }

            resource_metrics_key_attributes = [
              "service.name",
              "telemetry.sdk.language",
              "telemetry.sdk.name"
            ]
          }
        }

        receivers = {
          otlp = {
            protocols = {
              grpc = {
                endpoint = "$${env:MY_POD_IP}:4317"
              }

              http = {
                endpoint = "$${env:MY_POD_IP}:4318"
              }
            }
          }

          prometheus = {
            config = {
              scrape_configs = [
                {
                  job_name        = "opentelemetry-collector"
                  scrape_interval = "10s"

                  static_configs = [
                    {
                      targets = [
                        "$${env:MY_POD_IP}:8888"
                      ]
                    }
                  ]
                },
                {
                  job_name        = "opentelemetry-operator"
                  scrape_interval = "10s"

                  static_configs = [
                    {
                      targets = [
                        "opentelemetry-operator.opentelemetry:8080"
                      ]
                    }
                  ]
                }
              ]
            }
          }
        }

        service = {
          telemetry = {
            metrics = {
              address = "$${env:MY_POD_IP}:8888"
            }
          }

          extensions = [
            "health_check"
          ]

          pipelines = {
            logs = {
              exporters = [
                "debug",
                "otlphttp/coroot"
              ]

              processors = [
                "memory_limiter",
                "batch"
              ]

              receivers = [
                "otlp"
              ]
            }

            metrics = {
              exporters = [
                "debug",
                "prometheus"
              ]

              processors = [
                "memory_limiter",
                "batch"
              ]

              receivers = [
                "spanmetrics",
                "otlp",
                "prometheus"
              ]
            }

            traces = {
              exporters = [
                "debug",
                "spanmetrics",
                "otlphttp/tempo",
                "otlphttp/coroot"
              ]

              processors = [
                "memory_limiter",
                "batch"
              ]

              receivers = [
                "otlp"
              ]
            }
          }
        }
      }

      ports = {
        metrics = {
          enabled      = true
          containerPort = 8888
          servicePort   = 8888
          protocol      = "TCP"
        }

        data-exp = {
          enabled       = true
          containerPort = 8889
          servicePort   = 8889
          hostPort      = 8889
          protocol      = "TCP"
        }
      }
    })
  ]
}