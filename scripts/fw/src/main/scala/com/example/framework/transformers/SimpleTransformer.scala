package com.example.framework.transformers

import org.apache.spark.sql.DataFrame

object SimpleTransformer {
  def transform(df: DataFrame) = {
    df.dropDuplicates()
  }
}
