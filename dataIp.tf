# Create a data block to fetch your IP
data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}