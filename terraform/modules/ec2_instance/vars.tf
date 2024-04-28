variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "instance_ami" {
    type = map(string)
    default = {
        id = "ami-04b70fa74e45c3917"
        user = "ubuntu"
    }
}

variable "key-pair-name" {
    type = string
    default = "MlopsKeyPair"
}