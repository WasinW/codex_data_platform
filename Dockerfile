FROM apache/airflow:2.7.0

USER root
RUN apt-get update \
    && apt-get install -y curl gnupg \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
        > /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
        | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update \
    && apt-get install -y google-cloud-sdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER airflow
