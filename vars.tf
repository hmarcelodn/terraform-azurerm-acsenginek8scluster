variable "master_first_consecutive_static_ip" {
  type        = "string"
  description = "Master First Consecutive Static IP"
}

variable "agent_pool_count" {
  type        = "string"
  description = "Agent Pool Count"
}

variable "nodes_subnet_id" {
  type        = "string"
  description = "Kubernetes Nodes Subnet ID"
}

variable "master_subnet_id" {
  type        = "string"
  description = "Kubernetes Masters Subnet ID"
}

variable "subscription_id" {
  type        = "string"
  description = "Microsoft Azure Subscription ID"
}

variable "dns_prefix" {
  type        = "string"
  description = "DNS Cluster Prefix"
}

variable "location_name" {
  type        = "string"
  description = "Location for Kubernetes Cluster Name (East US 2, Central US, etc)"
}

variable "cluster_resource_group" {
  type        = "string"
  description = "Resource Group for ACS-ENGINE Deployment Resources"
}

variable "agents_subnet_name" {
  type        = "string"
  description = "Subnet Name used by Kubernetes Agents which will be used to the route table"
}

variable "masters_subnet_name" {
  type        = "string"
  description = "Subnet Name used by Kubernetes masters which will be used to the route table"
}

variable "vnet_name" {
  type        = "string"
  description = "Virtual Net Name"
}

variable "cluster_k8s_resource_group" {
  type = "string"
}

variable "master_count" {
  type        = "string"
  description = "Number of master nodes to be created"
}

variable "master_vm_size" {
  type        = "string"
  description = "Master Nodes Azure VM Size Type"
}

variable "node_vm_size" {
  type        = "string"
  description = "Agent Nodes Azure VM Size Type"
}

variable "rsa_public_key" {
  type        = "string"
  description = "RSA Public Key to login into the kubernetes cluster"
}

variable "terraform_account_name" {
  type        = "string"
  description = "Account Name where the acs-engine deployment output files will be uploaded to."
}

variable "terraform_container_name" {
  type        = "string"
  description = "Account Container Name where the acs-engine deployment output files will be uploaded to."
}

variable "terraform_account_key" {
  type        = "string"
  description = "Account Key where the acs-engine deployment output files will be uploaded to."
}

variable "service_principal_user" {
  type        = "string"
  description = "Subscription scoped service principal user which logins into azure to upload output files."
}

variable "service_principal_password" {
  type        = "string"
  description = "Subscription scoped service principal password user which logins into azure to upload output files."
}

variable "service_principal_tenant" {
  type        = "string"
  description = "Subscription scoped service principal tenant user which logins into azure to upload output files."
}

variable "service_principal_client_id" {
  type        = "string"
  description = "Cluster Service Principal used to self-provisioning."
}

variable "service_principal_client_secret" {
  type        = "string"
  description = "Cluster Service Principal Password used to self-provisioning."
}

variable "kubernetes_release_version" {
  type        = "string"
  description = "Kubernetes Release version to deploy."
}

variable "kubernetes_network_policy" {
  type        = "string"
  default     = "none"
  description = "Indicate network policy (azure, calico, none = kubenet ). Default: Kubenet"
}

variable "kubernetes_rbac_enabled" {
  type        = "string"
  default     = "false"
  description = "Indicates if the cluster RBAC is enabled."
}

variable "kubernetes_max_pods" {
  type        = "string"
  default     = "110"
  description = "Indicates the max number of pods to deploy by machine."
}
