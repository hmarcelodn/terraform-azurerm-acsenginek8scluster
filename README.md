# Terraform ACS-ENGINE Kubernetes

Terraform ACS-ENGINE is a module that can be used to create Production-Ready Kubernetes clusters easily.

## Dependencies

In order to work the module requires a few binaries to be installed in the build machine:

 - acs-engine >= v.0.13.1
 - az cli
 - Linux Operating System

## Process

Below is the process done by the module step by step described:

 1. Build the file ***kubernetes.json*** based on parameters which represents the Cluster Definition. Valid parameters are specified in the official documentation for acs-engine.
 2. Run acs-engine generate command line in order to produce ARM Templates and all rsa keys/kubeconfigs.
 3. When acs-engine execution is finished, az-cli will associate subnets to the route-table in order to communicate masters/agents subnets.
 4. Upload to an already existing blob storage all generated output files to back it up and be able to reuse this information to upgrade/scale the cluster.

**Note**: The module's user must create a VNET with 2 subnets, 1 for master vms and 1 for agent vms. Any CIDR range could be specified.

## Example

    module  "kubernetes_cluster"  {
    
	    source  =  "hmarcelodn/acsenginek8scluster/azurerm"
	    version  =  "1.0.3-beta.1"
	    master\_first\_consecutive\_static\_ip  =  "${var.master\_first\_consecutive\_static\_ip}"
	    subscription_id  =  "${var.subscription_id}"
	    agent\_pool\_count  =  "${var.agent\_pool\_count}"    
	    master_count  =  "${var.master_count}"    
	    nodes\_subnet\_id  =  "${azurerm_subnet.default_nodes.id}"    
	    master\_subnet\_id  =  "${azurerm_subnet.default_masters.id}"    
	    dns_prefix  =  "${var.dns_prefix}"    
	    subscription_id  =  "${var.subscription_id}"    
	    location_name  =  "${var.resource\_group\_location_short}"    
	    cluster\_resource\_group  =  "${var.resource\_group\_name_iaas}"    
	    agents\_subnet\_name  =  "${azurerm_subnet.default_nodes.name}"    
	    masters\_subnet\_name  =  "${azurerm_subnet.default_masters.name}"    
	    vnet_name  =  "${azurerm\_virtual\_network.default_iaas.name}"    
	    kubernetes\_release\_version  =  "${var.kubernetes\_release\_version}"    
	    cluster\_k8s\_resource_group  = "${var.resource\_group\_name_iaas}"    
	    master\_vm\_size  =  "${var.master\_vm\_size}"    
	    node\_vm\_size  =  "${var.node\_vm\_size}"    
	    service\_principal\_user  =  "${var.service\_principal\_user}"    
	    service\_principal\_password  =  "${var.service\_principal\_password}"    
	    service\_principal\_tenant  =  "${var.service\_principal\_tenant}"    
	    terraform\_account\_name  =  "${var.terraform\_account\_name}"    
	    terraform\_container\_name  =  "${var.terraform\_container\_name}"    
	    terraform\_account\_key  =  "${var.terraform\_account\_key}"    
	    rsa\_public\_key  =  "${var.rsa\_public\_key}"    
	    service\_principal\_client_id  =  "${var.service\_principal\_client_id}"    
	    service\_principal\_client_secret  =  "${var.service\_principal\_client_secret}"    
    }
