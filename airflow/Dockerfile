FROM apache/airflow:2.9.1-python3.9

# Copy your dbt profile into the container
COPY airflow/profiles.yml /home/airflow/.dbt/profiles.yml

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install uv and DBT dependencies
RUN pip install uv && \
    uv pip install --system \
    xmltodict==0.13.0 \
    airflow-dbt==0.4.0 \
    dbt-postgres==1.0.2

# Set permissions for airflow user
RUN chown -R airflow: /home/airflow/.dbt

USER airflow