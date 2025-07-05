Place compiled framework JARs here.

## Building

1. Install [sbt](https://www.scala-sbt.org/download.html).
2. In the repository root create a minimal `build.sbt` that depends on Spark:

   ```scala
   name := "codex-data-platform"
   version := "0.1"
   scalaVersion := "2.12.18"
   libraryDependencies ++= Seq(
     "org.apache.spark" %% "spark-core" % "3.5.0",
     "org.apache.spark" %% "spark-sql"  % "3.5.0"
   )
   ```

3. Run `sbt package` to produce `target/scala-2.12/codex-data-platform_2.12-0.1.jar`.
4. Copy the resulting JAR into this directory so it can be uploaded to GCS.

Place compiled framework jars here. The Airflow DAG expects a jar named
`framework.jar` to be uploaded to the corresponding path in your GCS bucket
(for example `gs://<your-bucket>/fw/lib/output/framework.jar`).
