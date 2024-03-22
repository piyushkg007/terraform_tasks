module "network" {
  source = "./network"
}

module "compute" {
  source = "./compute"
}

module "lb" {
  source = "./lb"
}
