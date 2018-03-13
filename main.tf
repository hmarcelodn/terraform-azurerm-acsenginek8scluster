# Create Kubernetes
data "template_file" "kubernetes" {
  template = "${file("${path.module}/templates/kubernetes.json.tpl")}"

  vars {
    master_subnet_id                   = "${var.master_subnet_id}"
    nodes_subnet_id                    = "${var.nodes_subnet_id}"
    master_first_consecutive_static_ip = "${var.master_first_consecutive_static_ip}"
    agent_pool_count                   = "${var.agent_pool_count}"
    master_count                       = "${var.master_count}"
    dns_prefix                         = "${var.dns_prefix}"
    master_vm_size                     = "${var.master_vm_size}"
    node_vm_size                       = "${var.node_vm_size}"
    rsa_public_key                     = "${var.rsa_public_key}"
    service_principal_client_id        = "${var.service_principal_client_id}"
    service_principal_client_secret    = "${var.service_principal_client_secret}"
    kubernetes_release_version         = "${var.kubernetes_release_version}"
    kubernetes_network_policy          = "${var.kubernetes_network_policy}"
    kubernetes_rbac_enabled            = "${var.kubernetes_rbac_enabled}"
    kubernetes_max_pods                = "${var.kubernetes_max_pods}"
  }
}

# Create Cluster Definition File
resource "null_resource" "kubernetes_cluster_definition" {
  provisioner "local-exec" {
    command = "cat > kubernetes.json <<EOL\n${join(",\n", data.template_file.kubernetes.*.rendered)}\nEOL"
  }

  depends_on = ["data.template_file.kubernetes"]
}

# Run ACS-Engine
resource "null_resource" "run_acs_engine" {
  provisioner "local-exec" {
    command = <<EOT
      az login --service-principal \
      -u ${var.service_principal_user} \
      -p ${var.service_principal_password} \
      --tenant ${var.service_principal_tenant}

      acs-engine generate --api-model kubernetes.json

      az group deployment create \
      --resource-group "${var.cluster_resource_group}" \
      --template-file "./_output/${var.dns_prefix}/azuredeploy.json" \
      --parameters "./_output/${var.dns_prefix}/azuredeploy.parameters.json"

      az account clear
    EOT
  }

  depends_on = [
    "null_resource.kubernetes_cluster_definition",
  ]
}

# Create Routing Tables Shell Script
resource "null_resource" "run_post_deployment" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Sleeping 3 minutes"
      sleep 3m
      echo "Sleeping 3 minutes elapsed"
      
      az login --service-principal \
      -u ${var.service_principal_user} \
      -p ${var.service_principal_password} \
      --tenant ${var.service_principal_tenant}

      az network vnet subnet update \
      -n ${var.agents_subnet_name} \
      -g ${var.cluster_resource_group} \
      --vnet-name ${var.vnet_name} \
      --route-table /subscriptions/${var.subscription_id}/resourceGroups/${var.cluster_k8s_resource_group}/providers/Microsoft.Network/routeTables/$(az network route-table list -g ${var.cluster_k8s_resource_group} | jq -r '.[].name')

      az network vnet subnet update \
      -n ${var.masters_subnet_name} \
      -g ${var.cluster_resource_group} \
      --vnet-name ${var.vnet_name} \
      --route-table /subscriptions/${var.subscription_id}/resourceGroups/${var.cluster_k8s_resource_group}/providers/Microsoft.Network/routeTables/$(az network route-table list -g ${var.cluster_k8s_resource_group} | jq -r '.[].name')

    EOT
  }

  depends_on = [
    "null_resource.run_acs_engine",
  ]
}

# Create and execute Upload Blobs from acs-engine
resource "null_resource" "run_upload_output_files" {
  provisioner "local-exec" {
    command = <<EOT
      az storage blob upload-batch \
      --source ./_output/${var.dns_prefix}/ \
      --destination ${var.terraform_account_name} \
      --account-name ${var.terraform_container_name} \
      --account-key ${var.terraform_account_key} 
    EOT
  }

  depends_on = [
    "null_resource.run_acs_engine",
  ]
}
