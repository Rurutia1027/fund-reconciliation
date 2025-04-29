FROM ubuntu:22.04

# Install Python 3.10 and dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common curl gnupg && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.10 python3.10-venv python3.10-dev python3-pip build-essential libpq-dev && \
    ln -sf /usr/bin/python3.10 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# Set working directory
WORKDIR /app

# Copy files into the container
COPY requirements.txt .
COPY generate.py .
COPY assets.py .

# Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Run your script by default
CMD ["python", "generate.py"]