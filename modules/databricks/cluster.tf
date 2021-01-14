resource "databricks_instance_pool" "dw" {
  instance_pool_name                    = "dw"
  min_idle_instances                    = 0 ### The minimum number of instances the pool keeps idle. These instances do not terminate, 
                                            ### regardless of the setting specified in Idle Instance Auto Termination. 
                                            ### If a cluster consumes idle instances from the pool, Databricks provisions additional instances to maintain the minimum.
  max_capacity                          = 10 ###  If a cluster using the pool requests more instances than this number during autoscaling, the request will fail with an INSTANCE_POOL_MAX_CAPACITY_FAILURE error.
  node_type_id                          = "Standard_DS3_v2"
  idle_instance_autotermination_minutes = 10
  preloaded_spark_versions              = ["7.5.x-scala2.12"] ### Latest version as per 5-10-2020

  custom_tags = var.common_azure_tags
}

resource "databricks_cluster_policy" "fair_use" {
  name = "Fair Use Policy"
  definition = jsonencode({
    "dbus_per_hour" : {
      "type" : "range",
      "maxValue" : 20
    },
    "autotermination_minutes" : {
      "type" : "fixed",
      "value" : 10,
      "hidden" : true
    },
    "custom_tags.Department" : {
      "type" : "fixed",
      "value" : "Marketing",
      "hidden" : true
    }
  })
}

/* resource "databricks_dbfs_file" "show_variables" {
  source          = "${path.module}/init.sh"
  content_b64_md5 = md5(filebase64("${path.module}/init.sh"))
  path            = "/init-scripts/show-variables.sh"
  overwrite       = true
  mkdirs          = true
} */

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = "Shared Autoscaling"
  instance_pool_id        = databricks_instance_pool.dw.id
  spark_version           = "7.5.x-scala2.12"
  policy_id               = databricks_cluster_policy.fair_use.id
  autotermination_minutes = 10

  autoscale {
    min_workers = 1
    max_workers = 10
  }

  spark_conf = {
    "spark.databricks.delta.preview.enabled": true,
    "spark.databricks.io.cache.enabled" : true,
    "spark.databricks.io.cache.maxDiskUsage" : "50g",
    "spark.databricks.io.cache.maxMetaDataCache" : "1g"
  }

  library {
    pypi {
      package = "fbprophet==0.6"
    }
  }

  library {
    maven {
      coordinates = "com.amazon.deequ:deequ:1.0.4"
    }
  }

  cluster_log_conf {
    dbfs {
      destination = "dbfs:/mnt/sample/cluster-logs"
    }
  }

  /* init_scripts {
    dbfs {
      destination = databricks_dbfs_file.show_variables.path
    }
  } */

  custom_tags = {
    Department = "Marketing"
    Order      = "New"
  }
}