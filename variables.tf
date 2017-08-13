variable "access_key" {
  default = ""
} 
variable "secret_key" {
  default = ""
} 

/* Global variables */

variable "keypair" {
  default = ""
}


variable "keyfile" {
  default = "terraform_key/key.pem"
} 

/* Region-specific setup is below. Uses
   multiple regions, "primary" & "backup" for DR. */

variable "region" {
  default { 
    "primary" = "eu-west-1"
    "backup" = "eu-west-2"
  }
}

variable "insttype" {
  default = {
    "utility" = "t2.micro"
    "cnode" = "t2.medium"
    "mnode" = "t2.medium"
  }
}

variable "ami" {
  default = {
    "eu-west-1" = "ami-0c771d7f"
    "eu-west-2" = "ami-1db2a779"
    "platform" = "CentOS 7"
  }
}

variable "azones" {
  default = {
    "eu-west-1" = "eu-west-1a,eu-west-1b,eu-west-1c"
    "eu-west-2" = "eu-west-2a,eu-west-2b"
  }
}

variable "count" {
  default = {
    "cnodes" = "3"
    "mnodes" = "3"
  }
}

variable "cluster_nodes" {
  default = {
    "0" = "cnode0"
    "1" = "cnode1"
    "2" = "cnode2"
    "3" = "cnode3"
    "4" = "cnode4"
    "5" = "cnode5"
  }
}

variable "master_nodes" {
  default = {
    "0" = "mnode0"
    "1" = "mnode1"
    "2" = "mnode2"
  }
}
