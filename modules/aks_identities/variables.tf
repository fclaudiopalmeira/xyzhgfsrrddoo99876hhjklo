variable "cluster_name" {
  description = "cluster name"
}

variable "common_azure_tags" {
  type = map(string)
  description = "Common Azure tags to be applied to all created resources."
}
