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
        host_network = "dorm"
      }

      port "rcon" {
        static       = 25575
        to           = 25575
        host_network = "dorm"
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

    service {
      name = "minecraft-rcon"
      port = "rcon"

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
        image = "itzg/minecraft-server"
        # ports = ["tcp", "rcon"]

        mounts = [
          {
            type = "bind"
            source = "/srv/file/ssd0/storage/minecraft"
            target = "/data"
            readonly = false
          },
        ]
      }

      env {
        MEMORY = "3G"
        EULA   = "TRUE"
      }

      resources {
        cpu = 4700
        memory = 4096
      }
    }
  }
}
