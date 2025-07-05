package com.example.framework.sinks

import org.apache.spark.sql.DataFrame

object ParquetSink {
  def write(df: DataFrame, path: String) = {
    df.write.mode("overwrite").parquet(path)
  }
}
