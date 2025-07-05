

# **The Complete Data Platform Blueprint: Architectural & Technical Design (Batch & Real-time)**

ฉบับที่: 4.0  
วัตถุประสงค์: เอกสารฉบับนี้เป็นพิมพ์เขียวฉบับสมบูรณ์ (Master Blueprint) ที่รวมเอกสารการออกแบบเชิงสถาปัตยกรรมและเชิงเทคนิคสำหรับ Batch และ Real-time Processing เข้าไว้ด้วยกัน มีเป้าหมายเพื่อกำหนดวิสัยทัศน์, กลยุทธ์, และแนวทางการปฏิบัติสำหรับการสร้าง Data Lakehouse Platform ที่ทันสมัย, ยืดหยุ่น, และมีประสิทธิภาพ เพื่อใช้เป็นเอกสารอ้างอิงสุดท้ายก่อนการสร้าง Prompt สำหรับการ Generate Code

---

## **ส่วนที่ 1: เอกสารสถาปัตยกรรม (Architectural Blueprint)**

ส่วนนี้มุ่งเน้นไปที่ "Why" และ "What" ของแพลตฟอร์ม เพื่อสร้างความเข้าใจร่วมกันในระดับกลยุทธ์

### **1.1 กรอบการทำงานแบบองค์รวม (The Unified 8-Layer Framework)**

สถาปัตยกรรม Data Lakehouse ที่เราจะสร้างขึ้น ประกอบด้วย 8 ชั้นการทำงานที่ชัดเจน ซึ่งรองรับทั้งงานแบบ Batch และ Streaming:

1. **Storage Layer:** ใช้ Cloud Object Storage (Amazon S3, ADLS, GCS) 1  
2. **Transactional Layer:** ใช้ Open Table Formats (แนะนำ **Apache Iceberg**) เพื่อให้มีคุณสมบัติ ACID สำหรับทั้ง Batch และ Streaming data 3  
3. **Compute & Framework Layer:** ใช้ **Apache Spark** เป็นเอนจิ้นหลักสำหรับทั้ง Batch Processing และ **Structured Streaming** และสร้าง Framework ที่ขับเคลื่อนด้วยไฟล์ config  
4. **Orchestration Layer:** ใช้ **Apache Airflow** สำหรับ Batch workflows และใช้กลไกของ Streaming engine เองในการทำงานต่อเนื่อง  
5. **Metadata & Governance Layer:** ใช้ Data Catalog เช่น **Unity Catalog** หรือ **DataHub/OpenMetadata** 7  
6. **Quality & Observability Layer:** ใช้ **Great Expectations** สำหรับ Data Quality และ **Prometheus & Grafana** สำหรับ Observability 11  
7. **CI/CD & DataOps Layer:** ใช้ **GitHub Actions** หรือ Jenkins ในการทำ Version Control, Automated Testing, และ Deployment 11  
8. **Serving Layer:** รองรับการใช้งานหลากหลายรูปแบบผ่าน **Trino**, **Materialized Views**, และ API สำหรับทั้งข้อมูลที่ผ่านการประมวลผลแบบ Batch และ Real-time 4

### **1.2 พิมพ์เขียวสถาปัตยกรรม 3 รูปแบบ (Architectural Blueprints)**

เราได้วิเคราะห์และสรุปสถาปัตยกรรม 3 รูปแบบหลัก ซึ่งแต่ละรูปแบบมีข้อดี-ข้อเสียที่แตกต่างกัน:

1. **รูปแบบที่ 1: The Integrated Platform (Databricks-Centric):**  
   * **แนวคิด:** แพลตฟอร์มเดียวครบวงจร พัฒนาเร็ว ลดภาระการจัดการ  
   * **เหมาะสำหรับ:** ทีมที่ต้องการความเร็วในการส่งมอบผลลัพธ์สูงสุด และยอมรับการผูกติดกับระบบนิเวศของ Databricks  
2. **รูปแบบที่ 2: The Composable Cloud (Cloud-Native: EMR/Dataproc):**  
   * **แนวคิด:** เลือกใช้บริการที่ดีที่สุดจากผู้ให้บริการคลาวด์รายเดียว (เช่น AWS) มาประกอบกัน มีความยืดหยุ่นสูง  
   * **เหมาะสำหรับ:** องค์กรที่มีการลงทุนในระบบนิเวศคลาวด์ใดคลาวด์หนึ่งอยู่แล้ว และมีทีมวิศวกรคลาวด์ที่แข็งแกร่ง  
3. **รูปแบบที่ 3: The DIY Powerhouse (Kubernetes-Native):**  
   * **แนวคิด:** สร้างทุกอย่างขึ้นมาเองบน Kubernetes เพื่อการควบคุมสูงสุดและไม่ผูกติดกับผู้ให้บริการ  
   * **เหมาะสำหรับ:** องค์กรขนาดใหญ่ที่มีทีม Platform Engineering ที่เชี่ยวชาญ K8s และต้องการสร้างมาตรฐานให้ทุก Workload ทำงานบน K8s

---

## **ส่วนที่ 2: เอกสารการออกแบบทางเทคนิค (Batch Processing)**

ส่วนนี้มุ่งเน้นไปที่ "How" ของแพลตฟอร์มสำหรับงาน Batch โดยจะลงลึกในรายละเอียดการออกแบบ **Data Processing Framework** ซึ่งเป็นส่วนประกอบหลักที่สามารถนำไปใช้ได้กับสถาปัตยกรรมทั้ง 3 รูปแบบ

### **2.1 ปรัชญาการออกแบบ Framework**

Framework ของเราจะถูกสร้างขึ้นบนปรัชญาหลัก 3 ประการ:

1. **Configuration-Driven:** การทำงานทั้งหมดของไปป์ไลน์ถูกควบคุมโดยไฟล์ YAML  
2. **Object-Oriented & Modular:** ออกแบบโค้ดในรูปแบบของคลาส (Classes) และโมดูล (Modules) ที่ชัดเจน  
3. **Extensible (ออกแบบมาเพื่อการต่อยอด):** สถาปัตยกรรมของ Framework ถูกออกแบบมาให้ง่ายต่อการเพิ่มความสามารถใหม่ๆ

### **2.2 มาตรฐานการเขียนโค้ดและโครงสร้างโปรเจกต์**

* **โครงสร้างโปรเจกต์ (Project Structure):**  
  data-platform-framework/  
  ├── configs/  
  │   ├── batch/  
  │   │   └── pipeline\_a.yml  
  │   └── streaming/  
  │       └── stream\_pipeline\_x.yml  
  ├── src/  
  │   └── framework/  
  │       ├── \_\_init\_\_.py  
  │       ├── main.py  
  │       ├── connectors/  
  │       ├── transformers/  
  │       ├── validators/  
  │       └── sinks/  
  ├── tests/  
  ├── pyproject.toml  
  └── README.md

* **มาตรฐานโค้ด (Coding Standards):** PEP 8, Google Style Docstrings, JSON Logging  
* **การจัดการ Dependencies:** Poetry

### **2.3 การออกแบบเชิงลึกของแต่ละโมดูล (Module Deep Dive)**

*(**หมายเหตุ:** รายละเอียดการออกแบบเชิงลึกของโมดูล Connectors, Transformers, Validators, และ Sinks สำหรับ Batch Processing ยังคงเหมือนเดิมตามเอกสารฉบับที่แล้ว)*

---

## **ส่วนที่ 3: การออกแบบสำหรับ Real-time/Near Real-time Data Processing**

ส่วนนี้จะขยายความสถาปัตยกรรมเพื่อรองรับการประมวลผลข้อมูลแบบสตรีมมิ่ง ซึ่งเป็นส่วนประกอบสำคัญในการสร้างแพลตฟอร์มที่ตอบสนองต่อเหตุการณ์ได้ทันท่วงที

### **3.1 สถาปัตยกรรมหลักและเทคโนโลยี**

การประมวลผลแบบ Real-time จะใช้ **Spark Structured Streaming** เป็นเอนจิ้นหลัก ซึ่งทำงานบนหลักการของ Micro-batch processing ทำให้สามารถใช้ API และ Logic เดียวกันกับ Batch processing ได้ในหลายกรณี

* **แหล่งข้อมูลสตรีมมิ่ง (Streaming Sources):** Apache Kafka, AWS Kinesis, Azure Event Hubs, Google Pub/Sub  
* **รูปแบบสถาปัตยกรรม:** เราจะใช้แนวทาง **Kappa Architecture** เป็นหลัก โดยมองว่าทุกอย่างคือสตรีม ข้อมูลจะไหลผ่านไปป์ไลน์การประมวลผลแบบสตรีมมิ่งอย่างต่อเนื่อง และข้อมูลแบบ Batch จะถูกมองว่าเป็น "สตรีมที่มีขนาดจำกัด" (Bounded Stream)

### **3.2 การออกแบบเชิงลึกของแต่ละขั้นตอน**

#### **ขั้นตอนที่ 1: การนำเข้าข้อมูลแบบสตรีมมิ่ง (Streaming Ingestion)**

* **หน้าที่:** นำเข้าข้อมูลจาก Message Queue (เช่น Kafka) อย่างต่อเนื่องและเขียนลงในตาราง Bronze ของ Lakehouse  
* **การทำงาน:**  
  1. ใช้ spark.readStream เพื่อเชื่อมต่อกับแหล่งข้อมูลสตรีมมิ่ง (e.g., Kafka)  
  2. ข้อมูลที่เข้ามามักจะเป็นรูปแบบ JSON หรือ Avro ซึ่งจะถูกเขียนลงในตาราง **Bronze** (Delta/Iceberg) โดยตรงในรูปแบบดิบ  
  3. การเขียนจะใช้ df.writeStream พร้อมกับกำหนด **Checkpoint Location** ซึ่งเป็นสิ่งสำคัญอย่างยิ่งในการติดตามสถานะของสตรีมและทำให้สามารถกู้คืนสถานะได้หากเกิดข้อผิดพลาด

#### **ขั้นตอนที่ 2: การประมวลผลแบบสตรีมมิ่ง (Streaming Transformation)**

* **หน้าที่:** แปลงข้อมูลจากตาราง Bronze ไปยัง Silver และ Gold อย่างต่อเนื่อง  
* **การทำงาน (Streaming Medallion Architecture):**  
  1. **Bronze to Silver:** สร้าง Streaming Job ที่อ่านข้อมูลจากตาราง Bronze (spark.readStream.format("delta").table("bronze\_table"))  
  2. ทำการ Cleanse, Validate, และ Enrich ข้อมูล (สามารถใช้ Transformers ที่ออกแบบไว้ในส่วนที่ 2 ได้)  
  3. เขียนผลลัพธ์ลงในตาราง **Silver** แบบสตรีมมิ่ง (writeStream)  
  4. **Silver to Gold:** สร้าง Streaming Job อีกตัวเพื่ออ่านข้อมูลจากตาราง Silver, ทำการ Aggregate หรือ Join เพื่อสร้างข้อมูลที่พร้อมใช้งานสำหรับธุรกิจ และเขียนลงในตาราง **Gold**

### **3.3 รูปแบบการให้บริการข้อมูลแบบ Real-time (Real-time Serving Patterns)**

การนำข้อมูลที่ประมวลผลแล้วไปใช้งานในระดับ Real-time ต้องการสถาปัตยกรรมที่ตอบสนองด้วยความหน่วงต่ำ (Low Latency) เราจะใช้ 2 รูปแบบหลัก:

#### **รูปแบบ A: Materialized Views for Low-Latency Analytics**

* **กรณีการใช้งาน:** แดชบอร์ด BI, การวิเคราะห์เชิงโต้ตอบที่ต้องการข้อมูลล่าสุด  
* **แนวคิด:** สร้างตารางที่ผ่านการคำนวณล่วงหน้า (Pre-computed) ซึ่งจะถูกอัปเดตโดยอัตโนมัติเมื่อมีข้อมูลใหม่เข้ามาในสตรีม ทำให้การคิวรีข้อมูลจากแดชบอร์ดรวดเร็วมาก เพราะไม่ต้องคำนวณใหม่ทุกครั้ง 22  
* **การนำไปใช้:**  
  * **ใน Databricks:** สามารถใช้ฟีเจอร์ **Materialized Views** และ **Streaming Tables** ได้โดยตรง ซึ่งสร้างขึ้นบน Delta Live Tables และจะทำการรีเฟรชข้อมูลแบบเพิ่มหน่วย (Incrementally) โดยอัตโนมัติ 23  
  * **ในสถาปัตยกรรมแบบเปิด:** สามารถสร้าง Streaming Job ที่ทำหน้าที่คล้ายกัน โดยอ่านข้อมูลจากตาราง Gold และเขียนผลลัพธ์ที่ Aggregate แล้วลงในตารางใหม่ (Materialized View Table) ที่ออกแบบมาเพื่อการคิวรีที่รวดเร็ว

#### **รูปแบบ B: Reverse ETL for Operational Systems**

* **กรณีการใช้งาน:** การส่งข้อมูลลูกค้าล่าสุดไปยังระบบ CRM, การอัปเดต Product Catalog ในแอปพลิเคชัน E-commerce, การส่งข้อมูลสำหรับ Fraud Detection Engine  
* **แนวคิด:** กระบวนการย้ายข้อมูลที่ผ่านการคัดสรรและเสริมคุณค่าแล้วจาก Lakehouse (Gold Layer) *กลับเข้าไปยัง* ระบบปฏิบัติการ (Operational Systems) เช่น ฐานข้อมูล NoSQL ที่มีความหน่วงต่ำ 3  
* การนำไปใช้ (Two-Stage Process) 3:  
  1. **Initial Batch Load:** ทำการโหลดข้อมูลทั้งหมดจากตาราง Gold ไปยัง Operational Database (เช่น Azure Cosmos DB, Amazon DynamoDB) หนึ่งครั้งเพื่อสร้างสถานะเริ่มต้น  
  2. **Continuous CDC Sync:**  
     * สร้าง Streaming Job ที่ใช้ฟีเจอร์ **Change Data Capture (CDC)** ของ Delta Lake หรือ Iceberg (readChangeData \= true) เพื่ออ่านเฉพาะข้อมูลที่มีการเปลี่ยนแปลง (Insert, Update, Delete) จากตาราง Gold 3  
     * ใช้ writeStream และ forEachBatch เพื่อเขียนการเปลี่ยนแปลงเหล่านี้ไปยัง Operational Database อย่างต่อเนื่องในระดับ Near Real-time  
     * Operational Database นี้จะทำหน้าที่เป็น Backend สำหรับ **API Serving Layer** ที่ให้บริการข้อมูลแก่แอปพลิเคชันต่างๆ

### **2.4 ตัวอย่างไฟล์ Configuration สำหรับ Streaming (config/streaming/stream\_pipeline\_x.yml)**

YAML

pipeline\_name: "realtime\_order\_processing"  
description: "Continuously processes order events from Kafka."

source:  
  type: "kafka"  
  config:  
    kafka.bootstrap.servers: "kafka-broker:9092"  
    subscribe: "raw\_orders\_topic"  
    startingOffsets: "latest"

transformations:  
  \- type: "json\_parser"  
    config:  
      source\_column: "value"  
      target\_schema: "order\_id STRING, customer\_id STRING, amount DOUBLE, timestamp TIMESTAMP"  
  \- type: "sql"  
    config:  
      view\_name: "orders\_view"  
      sql\_query: "SELECT \*, 'PROCESSED' as status FROM orders\_view WHERE amount \> 0"

\# Validation สามารถทำใน stream ได้ แต่ส่วนใหญ่มักจะ Quarantined ข้อมูลที่ไม่ผ่าน  
\# แทนที่จะหยุด Pipeline

sink:  
  type: "delta\_stream"  
  config:  
    path: "s3://my-lakehouse/silver/processed\_orders"  
    checkpointLocation: "s3://my-lakehouse/checkpoints/silver\_processed\_orders"  
    outputMode: "append"  
    trigger:  
      processingTime: "1 minute" \# ประมวลผลทุกๆ 1 นาที

---

## **ส่วนที่ 4: แนวทางปฏิบัติข้ามสายงาน (Cross-Cutting Best Practices)**

*(**หมายเหตุ:** รายละเอียดในส่วนนี้ยังคงเหมือนเดิม แต่ตอนนี้จะครอบคลุมทั้ง Batch และ Streaming Workloads)*

### **4.1 กลยุทธ์ FinOps (การจัดการต้นทุน)**

### **4.2 CI/CD และ DataOps**

### **4.3 Data Governance Framework**

---

## **ส่วนที่ 5: กรอบการตัดสินใจและขั้นตอนต่อไป**

เอกสารฉบับนี้จึงครอบคลุมทั้ง Batch และ Real-time/Near Real-time Data Processing ทำให้เป็นพิมพ์เขียวที่สมบูรณ์สำหรับการสร้าง Data Platform ที่ทันสมัย

### **5.1 เมทริกซ์การตัดสินใจเชิงกลยุทธ์**

*(เมทริกซ์ยังคงเดิม แต่ตอนนี้การประเมินจะรวมความสามารถในการจัดการ Streaming Workloads ของแต่ละแพลตฟอร์มเข้าไปด้วย)*

### **5.2 คำถามสำคัญที่ต้องตอบ**

*(คำถามยังคงเดิม แต่ตอนนี้ท่านสามารถพิจารณาได้ว่าสถาปัตยกรรมใดจะตอบโจทย์ทั้ง Batch และ Real-time ได้ดีที่สุดในบริบทขององค์กรท่าน)*

### **5.3 ขั้นตอนต่อไป: การสร้าง Master Prompt**

หลังจากที่ท่านได้ทบทวนและยืนยันแนวทางจากเอกสารฉบับสมบูรณ์นี้แล้ว ขั้นตอนต่อไปคือการนำองค์ความรู้ทั้งหมดมาสร้างเป็น **"Master Prompt"** ที่มีความละเอียดสูง ซึ่งจะใช้เป็นคำสั่งในการ Generate โค้ดและไฟล์ Configuration ต่างๆ ตามสถาปัตยกรรมที่ท่านเลือกได้อย่างมีประสิทธิภาพและครบถ้วนสมบูรณ์

#### **Works cited**

1. Data Lakehouse: A modern data Architecture | by Sandeep Kaushik \- Medium, accessed July 5, 2025, [https://medium.com/@shyamsandeep28/data-lakehouse-a-modern-data-architecture-3dd3e1c89f92](https://medium.com/@shyamsandeep28/data-lakehouse-a-modern-data-architecture-3dd3e1c89f92)  
2. Apache Spark vs. Azure Databricks vs. Kubernetes Comparison \- SourceForge, accessed July 5, 2025, [https://sourceforge.net/software/compare/Apache-Spark-vs-Azure-Databricks-vs-Kubernetes/](https://sourceforge.net/software/compare/Apache-Spark-vs-Azure-Databricks-vs-Kubernetes/)  
3. Data Lakehouse: Guide to Modern Architecture & Migration ..., accessed July 5, 2025, [https://www.analytics8.com/blog/data-lakehouse-explained-building-a-modern-and-scalable-data-architecture/](https://www.analytics8.com/blog/data-lakehouse-explained-building-a-modern-and-scalable-data-architecture/)  
4. Ecosystem: Data lake components \- Trino, accessed July 5, 2025, [https://trino.io/ecosystem/data-lake.html](https://trino.io/ecosystem/data-lake.html)  
5. What is a data lakehouse? \- Databricks Documentation, accessed July 5, 2025, [https://docs.databricks.com/aws/en/lakehouse/](https://docs.databricks.com/aws/en/lakehouse/)  
6. The journey from Presto to Trino and Starburst | Starburst, accessed July 5, 2025, [https://www.starburst.io/blog/the-journey-from-presto-to-trino-and-starburst/](https://www.starburst.io/blog/the-journey-from-presto-to-trino-and-starburst/)  
7. What Is a Data Governance Framework? Guide & Examples \- Atlan, accessed July 5, 2025, [https://atlan.com/data-governance-framework/](https://atlan.com/data-governance-framework/)  
8. OpenMetadata vs. DataHub: Compare Architecture, Capabilities, Integrations & More \- Atlan, accessed July 5, 2025, [https://atlan.com/openmetadata-vs-datahub/](https://atlan.com/openmetadata-vs-datahub/)  
9. OpenMetadata vs Amundsen vs DataHub: Comparison | bugfree.ai, accessed July 5, 2025, [https://bugfree.ai/knowledge-hub/openmetadata-vs-amundsen-vs-datahub-comparison](https://bugfree.ai/knowledge-hub/openmetadata-vs-amundsen-vs-datahub-comparison)  
10. Why should I use Great Expectations if I already have tests in DBT? \- Reddit, accessed July 5, 2025, [https://www.reddit.com/r/dataengineering/comments/193eced/why\_should\_i\_use\_great\_expectations\_if\_i\_already/](https://www.reddit.com/r/dataengineering/comments/193eced/why_should_i_use_great_expectations_if_i_already/)  
11. Great Expectations vs. dbt Tests: What's the Difference | DistantJob, accessed July 5, 2025, [https://distantjob.com/blog/great-expectations-dbt/](https://distantjob.com/blog/great-expectations-dbt/)  
12. A DataOps Implementation Guide with dbt, Airflow, and Great Expectations | Uplatz Blog, accessed July 5, 2025, [https://uplatz.com/blog/a-dataops-implementation-guide-with-dbt-airflow-and-great-expectations/](https://uplatz.com/blog/a-dataops-implementation-guide-with-dbt-airflow-and-great-expectations/)  
13. dbt-expectations: What it is and how to use it to find data quality issues | Metaplane, accessed July 5, 2025, [https://www.metaplane.dev/blog/dbt-expectations](https://www.metaplane.dev/blog/dbt-expectations)  
14. Integrating OpenTelemetry with Grafana for Better Observability | Last9, accessed July 5, 2025, [https://last9.io/blog/opentelemetry-with-grafana/](https://last9.io/blog/opentelemetry-with-grafana/)  
15. Monitoring Apache Spark with Prometheus on Kubernetes \- Outshift \- Cisco, accessed July 5, 2025, [https://outshift.cisco.com/blog/spark-monitoring](https://outshift.cisco.com/blog/spark-monitoring)  
16. Kubernetes Metrics and Monitoring with Prometheus and Grafana \- DEV Community, accessed July 5, 2025, [https://dev.to/abhay\_yt\_52a8e72b213be229/kubernetes-metrics-and-monitoring-with-prometheus-and-grafana-4e9n](https://dev.to/abhay_yt_52a8e72b213be229/kubernetes-metrics-and-monitoring-with-prometheus-and-grafana-4e9n)  
17. CI/CD for Data Teams: Roadmap to Reliable Pipelines \- Ascend.io, accessed July 5, 2025, [https://www.ascend.io/blog/ci-cd-for-data-teams-a-roadmap-to-reliable-data-pipelines](https://www.ascend.io/blog/ci-cd-for-data-teams-a-roadmap-to-reliable-data-pipelines)  
18. Power BI \+ Databricks: Secrets to Performance, Security & Integration \- YouTube, accessed July 5, 2025, [https://www.youtube.com/watch?v=RdM3EWsyT80](https://www.youtube.com/watch?v=RdM3EWsyT80)  
19. Materialized Views: A Clear-Cut Definition and Guide \- Databricks, accessed July 5, 2025, [https://www.databricks.com/glossary/materialized-views](https://www.databricks.com/glossary/materialized-views)  
20. Reverse extract, transform, & load (ETL) \- Azure Cosmos DB for NoSQL | Microsoft Learn, accessed July 5, 2025, [https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/reverse-extract-transform-load](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/reverse-extract-transform-load)  
21. Lessons Learned from Building an API on a Lakehouse with Cosmos DB & Azure Function, accessed July 5, 2025, [https://www.element61.be/en/resource/lessons-learned-building-api-lakehouse-cosmos-db-azure-function](https://www.element61.be/en/resource/lessons-learned-building-api-lakehouse-cosmos-db-azure-function)  
22. 5 Layers Of Data Lakehouse Architecture Explained \- Monte Carlo Data, accessed July 5, 2025, [https://www.montecarlodata.com/blog-data-lakehouse-architecture-5-layers/](https://www.montecarlodata.com/blog-data-lakehouse-architecture-5-layers/)  
23. AWS EMR vs Databricks: 9 Essential Differences (2025) \- Chaos Genius, accessed July 5, 2025, [https://www.chaosgenius.io/blog/aws-emr-vs-databricks/](https://www.chaosgenius.io/blog/aws-emr-vs-databricks/)  
24. What Is a Data Lakehouse? Key Features & Benefits Explained \- Rivery, accessed July 5, 2025, [https://rivery.io/data-learning-center/what-is-a-data-lakehouse-the-essential-guide/](https://rivery.io/data-learning-center/what-is-a-data-lakehouse-the-essential-guide/)  
25. Data Lakehouse Design Patterns For Multi Cloud | by Ganapathy Subramanian.N | Medium, accessed July 5, 2025, [https://medium.com/@trustngs/data-lakehouse-design-patterns-for-multi-cloud-70d1ddb34b38](https://medium.com/@trustngs/data-lakehouse-design-patterns-for-multi-cloud-70d1ddb34b38)  
26. Best practices for cost optimization \- Databricks Documentation, accessed July 5, 2025, [https://docs.databricks.com/aws/en/lakehouse-architecture/cost-optimization/best-practices](https://docs.databricks.com/aws/en/lakehouse-architecture/cost-optimization/best-practices)