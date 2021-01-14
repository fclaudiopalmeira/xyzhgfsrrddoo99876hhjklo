resource "databricks_group" "dsupport" {
  display_name = "Decision Support Team"
}

resource "databricks_scim_user" "first" {
  user_name    = "dsupport-member-1@example.com"
  display_name = "Decision Support Team"
  default_roles = []
  set_admin    = false
}

resource "databricks_group_member" "first" {
  group_id  = databricks_group.dsupport.id
  member_id = databricks_scim_user.first.id
}
/* 
resource "databricks_group" "support" {
  display_name = "Support"
}
 */
resource "databricks_scim_user" "second" {
  user_name    = "dsupport-member-2@example.com"
  display_name = "Decision Support Team"
  default_roles = []
  set_admin    = false
}

resource "databricks_group_member" "second" {
  group_id  = databricks_group.dsupport.id
  member_id = databricks_scim_user.second.id
}