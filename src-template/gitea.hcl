# gitea

job "gitea" {
  region      = "global"
  datacenters = ["tvcxdc"]

  type = "service"

  constraint {
    attribute = "${attr.unique.consul.name}"
    value     = "tvcxserver"
  }

  group "gitea" {
    count = 1

    network {
      mode = "bridge"

      port "http" {
        to = 3000
        host_network = "tvcxdorm"
      }
      port "ssh" {
        static       = 2200
        to           = 22
        host_network = "tvcxdorm"
      }
    }

    volume "ca-certificates" {
      type      = "host"
      source    = "ca-certificates"
      read_only = true
    }

    volume "localtime" {
      type      = "host"
      source    = "localtime"
      read_only = true
    }

    task "gitea" {
      driver = "docker"

      config {
        image = "gitea/gitea:1.12.5"
        ports = ["http", "ssh"]

        mounts = [
          {
            type = "bind"
            source = "/srv/file/storage/gitea"
            target = "/data"
            readonly = false
          },
        ]
      }

      volume_mount {
        volume      = "ca-certificates"
        destination = "/etc/ssl/certs"
      }
      volume_mount {
        volume      = "localtime"
        destination = "/etc/localtime"
      }

      env {
        USER_UID  = "1000"
        GROUP_GID = "1000"
      }

      service {
        name = "gitea"
        tags = ["urlprefix-gitea.service.cons.ul/"]

        # address_mode = "host"
        port         = "http"

        check {
          name         = "Check main HTML page."
          port         = "http"
          type         = "http"
          path         = "/"
          method       = "GET"
          interval     = "60s"
          timeout      = "10s"
          # address_mode = "host"
        }
      }
    }
  }
}
