# minecraft

job "minecraft" {
  region      = "global"
  datacenters = ["tvcxdc"]

  type = "service"

  constraint {
    attribute = "${attr.unique.consul.name}"
    value     = "tvcxserver"
  }

  group "minecraft" {
    count = 1

    network {
      mode = "bridge"

      port "tcp" {
        static       = 25565
        to           = 25565
        host_network = "tvcxdorm"
      }
    }

    service {
      name = "minecraft"
      port = "tcp"

      check {
        name         = "Check TCP socket port."
        port         = "tcp"
        type         = "tcp"
        interval     = "60s"
        timeout      = "10s"
      }
    }

    task "minecraft" {
      driver = "docker"

      config {
        image = "phyremaster/papermc"
        ports = ["tcp"]

        mounts = [
          {
            type = "bind"
            source = "/srv/file/storage/minecraft"
            target = "/papermc"
            readonly = false
          },
        ]
      }

      env {
        MC_RAM      = "4G"
        MC_VERSION  = "1.16.3"
        PAPER_BUILD = "240"
      }

      resources {
        cpu = 4700
        memory = 4096
      }
    }
  }
}
