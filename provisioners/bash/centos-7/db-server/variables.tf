variable "public_key" {}
variable "key_file_path" {}
variable "user_login" {
    default = "root"
}
variable "servers" {
    description = "The number of servers to provision"
}
variable "server_ips" {
    type = "list"
    description = "A list of ips of the servers to provision"
}
variable "server_ids" {
    type = "list"
    default = [""]
    description = "A list of ids of the servers to provision"
}

