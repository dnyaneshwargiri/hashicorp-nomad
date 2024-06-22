job "instagram-post" {
  datacenters = ["dc1"]

  group "instagram-post-group" {
    count = 1
    task "node" {
      driver = "docker"
      // volume_mount {
      //   # Assuming the tar file resides in /path/to/images
      //   source = "/path/to/images"
      //   destination = "/images" # Mount point inside the container
      //   read_only = false
      // }
      artifact {
          source = "http://localhost:9090/instagram-post.tar"
          options {
            archive = false
          }
      }

       config {
        load ="instagram-post.tar"
        image = "instagram-post"
        ports = ["http"] 
      }

      resources {
        cpu    = 500
        memory = 256
      }

      service {
        name = "node-service"
        port = "http"

        check {
          name     = "http"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      env {
        NODE_ENV = "production"
      }
    }

     network {
        port "http" {
          static = 3000
      }
    }
  }
}
