package com.example.framework.validators

import org.apache.spark.sql.DataFrame

object SimpleValidator {
  def validate(df: DataFrame): Boolean = {
    !df.columns.isEmpty
  }
}
