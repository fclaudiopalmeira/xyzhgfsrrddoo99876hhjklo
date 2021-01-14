###The following is going o create an empty notebook
resource "databricks_notebook" "notebook" {
  content = base64encode("# Welcome to your Python notebook")
  path = "/mynotebook"
  overwrite = false
  mkdirs = true
  language = "PYTHON"
  format = "SOURCE"
}
