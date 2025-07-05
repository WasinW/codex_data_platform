import org.apache.spark.sql.SparkSession
import scala.io.Source

case class JobConfig(inputPath: String, outputPath: String)

object SimpleJob {

  private def parseConfig(path: String): JobConfig = {
    val lines = Source.fromFile(path).getLines().toList
    val input = lines
      .find(_.trim.startsWith("input_path:"))
      .map(_.split(":", 2)(1).trim)
      .getOrElse(throw new IllegalArgumentException("input_path not found in config"))
    val output = lines
      .find(_.trim.startsWith("output_path:"))
      .map(_.split(":", 2)(1).trim)
      .getOrElse(throw new IllegalArgumentException("output_path not found in config"))
    JobConfig(input, output)
  }

  def main(args: Array[String]): Unit = {
    val config = args.length match {
      case 1 => parseConfig(args(0))
      case 2 => JobConfig(args(0), args(1))
      case _ =>
        System.err.println("Usage: SimpleJob <config.yml> or SimpleJob <input> <output>")
        sys.exit(1)
    }

    val spark = SparkSession.builder.appName("SimpleJob").getOrCreate()

    val df = spark.read.format("parquet").load(config.inputPath)
    val rowCount = df.count()
    import spark.implicits._
    Seq(rowCount).toDF("row_count").write.mode("overwrite").format("parquet").save(config.outputPath)

    spark.stop()
  }
}
