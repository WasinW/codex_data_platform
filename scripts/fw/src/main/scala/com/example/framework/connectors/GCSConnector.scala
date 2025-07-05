package com.example.framework.connectors

import org.apache.spark.sql.SparkSession

object GCSConnector {
  def readParquet(spark: SparkSession, path: String) = {
    spark.read.parquet(path)
  }
}
