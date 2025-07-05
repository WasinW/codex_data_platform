package com.example.jobs

import com.example.framework.connectors.GCSConnector
import com.example.framework.transformers.SimpleTransformer
import com.example.framework.validators.SimpleValidator
import com.example.framework.sinks.ParquetSink
import org.apache.spark.sql.SparkSession

object SimpleJob {
  def main(args: Array[String]): Unit = {
    if (args.length != 2) {
      throw new IllegalArgumentException("Usage: SimpleJob <input> <output>")
    }

    val spark = SparkSession.builder().appName("SimpleJob").getOrCreate()

    val input = args(0)
    val output = args(1)

    val df = GCSConnector.readParquet(spark, input)
    if (SimpleValidator.validate(df)) {
      val transformed = SimpleTransformer.transform(df)
      ParquetSink.write(transformed, output)
    } else {
      throw new RuntimeException("Validation failed")
    }

    spark.stop()
  }
}
