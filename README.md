# Terraform Cookbook

* A use case of map

```variable "bq_iam_role_bindings" {

  default = {
    "member1" = {
      "dataset1" : ["role1","role2", "role5"],
      "dataset2" : ["role3","role2"],
    },
    "member2" = {
      "dataset3" : ["role1","role4"],
      "dataset2" : ["role5"],
    } 
  }
}

locals {

  helper_list = flatten([for member, value in var.bq_iam_role_bindings:
                 flatten([for dataset, roles in value: 
                           [for role in roles:
                            {"member" = member
                            "dataset" = dataset
                            "role" = role}
                         ]])
                   ])
}
```

* Result
```
[
  {
    "dataset" = "dataset1"
    "member" = "member1"
    "role" = "role1"
  },
  {
    "dataset" = "dataset1"
    "member" = "member1"
    "role" = "role2"
  },
  {
    "dataset" = "dataset1"
    "member" = "member1"
    "role" = "role5"
  },
  {
    "dataset" = "dataset2"
    "member" = "member1"
    "role" = "role3"
  },
  {
    "dataset" = "dataset2"
    "member" = "member1"
    "role" = "role2"
  },
  {
    "dataset" = "dataset2"
    "member" = "member2"
    "role" = "role5"
  },
  {
    "dataset" = "dataset3"
    "member" = "member2"
    "role" = "role1"
  },
  {
    "dataset" = "dataset3"
    "member" = "member2"
    "role" = "role4"
  },
]
```

* Use Case
```resource "google_bigquery_dataset_iam_binding" "reader" {

  for_each =  { for idx, record in local.helper_list : idx => record }

  dataset_id = each.value.dataset
  role       = each.value.role

  members = [
    each.value.member
  ]
}
```
* Reference
https://stackoverflow.com/questions/63500554/terraform-iterate-over-nested-map

