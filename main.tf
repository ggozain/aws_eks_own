data "tfe_outputs" "vpc" {
  organization = "gozain-lab"
  workspace = "aws_vpc"
}

module "aws_eks"{
    source = "./modules/aws_eks"
    subnet_ids = setunion(
        data.tfe_outputs.vpc.values.public_subnet_id,
        data.tfe_outputs.vpc.values.private_subnet_id )
}