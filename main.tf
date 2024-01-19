locals {
  nodejs_runtimes   = ["nodejs20.x", "nodejs18.x", "nodejs16.x"]
  lambda_layer_name = (var.layer_name == "null") ? "lib-nodejs-${var.library_name}" : var.layer_name
  lambda_runtime    = contains(local.nodejs_runtimes, var.nodejs_runtime) ? var.nodejs_runtime : local.nodejs_runtimes[0]
}

locals {
  temp_folder    = "lambdalayer"
  package_file   = "${local.temp_folder}\\nodejs-${var.library_name}.zip"

  package_source = "${local.temp_folder}\\${var.library_name}"
  project_folder = "${local.package_source}\\nodejs"
  metadata_file  = "${local.project_folder}\\package.json"
}

# create folders and a dummy file
resource "local_file" "package_json" {
  content  = <<EOF
{
  "name": "${local.lambda_layer_name}",
  "version": "1.0.0",
  "description": "Node.js library to create Lambda Layer",
  "main": "index.js",
  "scripts": {
    "test": "echo test"
  },
  "author": "TechieInYou",
  "license": "ISC"
} 
EOF
  filename = local.metadata_file
}

# waiting to get the folders and dummy file created
resource "time_sleep" "until_folder_creation" {
  depends_on      = [local_file.package_json]
  create_duration = "1s"
}

# installing Node.js library
resource "null_resource" "install_nodejs_library" {

  depends_on = [time_sleep.until_folder_creation]

  # trigger on timestamp change will make sure local-exec runs always
  triggers = {
    always_run = "${timestamp()}"
  }

  # skip this block if the package already exists
  count = fileexists(pathexpand(local.package_file)) ? 0 : 1

  # install Node.js library
  provisioner "local-exec" {
    command = "cd ${local.project_folder} && npm install ${var.library_name}"
  }
}

# waiting until library installation completes
resource "time_sleep" "until_install_completion" {
  depends_on      = [null_resource.install_nodejs_library]
  create_duration = "10s"
}

# create package to upload to Lambda Layer
data "archive_file" "create_package" {

  depends_on = [time_sleep.until_install_completion]

  count = fileexists(pathexpand(local.package_file)) ? 0 : 1

  type        = "zip"
  source_dir  = local.package_source
  output_path = local.package_file
}

# creates lambda layer
resource "aws_lambda_layer_version" "nodejs_library" {
  depends_on          = [data.archive_file.create_package]
  filename            = local.package_file
  layer_name          = local.lambda_layer_name
  compatible_runtimes = [var.nodejs_runtime]
}
