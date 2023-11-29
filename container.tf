# Header Terraform
terraform {
  required_providers {
    docker={
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }

}

# Provider Docker on Linux 
provider "docker"{

host="unix:///var/run/docker.sock"

}

# Creating a Docker Image Nginx with the latest as the Tag.

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "nginx-test"
volumes {
  volume_name = docker_volume.nginx_volume.name
  container_path = "/usr/share/nginx/html/"

  }

  ports {
    internal = 80
    external = 8900
  }
    
  networks_advanced {
    name = docker_network.private_network.name
    ipv4_address = "10.33.68.5"

  }
  hostname = "nginx-test"  
  restart = "always"
  
  
   

}
resource "docker_network" "private_network" {
  name = "nginx_network"
  driver = "bridge"
  ipam_config {
    
    subnet = "10.33.68.0/24"
    gateway = "10.33.68.1"
  }
  
}

resource "docker_volume" "nginx_volume" {  
  name = "nginx_volume"  
   
}

