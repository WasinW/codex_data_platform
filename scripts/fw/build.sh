#!/bin/bash
set -e
cd $(dirname $0)
sbt package
cp target/scala-*/fw_*.jar lib/output/framework.jar
