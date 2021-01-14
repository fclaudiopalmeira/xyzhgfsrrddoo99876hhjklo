# Azure Databricks workspaces within CDHB VNet

## providers.tf
* Declares the providers being used.

## cluster.tf

* Create databricks instance pool
* Create databricks cluster

## databricks.tf

* Gather all entities of Azure Databricks workspace inside, including mounts

## init.tf

* creates random local prefix variable for all resources

## notebook.tf
* Creates Databricks notebook

## storage.tf

* Creates StorageV2 account and storage container

## users_and_groups.tf
* Create Databricks groups and users

## workspace.tf

* Creates Azure Databricks workspace in VNet


## output.tf
* Outputs values coming from the resources to be used by variables


