resource "marathon_app" "app-create-example" {
  app_id = "/app-create-example"
  cmd = "env && python3 -m http.server 8080"
  cpus = 0.01
  gpus = 0
  disk = 0
  instances = 1
  mem = 50
  max_launch_delay_seconds = 3000
  ports = [0, 0]

  container {
    docker {
      image = "python:3"
      network = "BRIDGE"
      parameters {
        parameter {
          key = "hostname"
          value = "a.corp.org"
        }
      }
      port_mappings {
        port_mapping {
          container_port = 8080
          host_port = 0
          protocol = "tcp"
          labels {
            VIP_0 = "test:8080"
          }
        }
        port_mapping {
          container_port = 161
          host_port = 0
          protocol = "udp"
          name = "port161"
        }
      }
    }

    volumes {
      volume {
        container_path = "examplepath"
        mode = "RW"
        persistent {
          size = 10
        }
      }
    }
  }

  env {
    TEST = "hey"
    OTHER_TEST = "nope"
  }

  health_checks {
     health_check {
       command {
         value = "ps aux |grep python"
       }
       max_consecutive_failures = 0
       protocol = "COMMAND"
     }
  }

  kill_selection = "OLDEST_FIRST"

  labels {
    test = "abc"
  }

  residency {
    task_lost_behavior = "WAIT_FOREVER"
    relaunch_escalation_timeout_seconds = 60
  }

  upgrade_strategy {
    minimum_health_capacity = 0
    maximum_over_capacity = 0
  }
}
