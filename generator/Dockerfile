FROM python:latest

RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian bookworm main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian bookworm-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y wget

ARG POSTGRES_USER
ARG POSTGRES_PASSWORD

ENV POSTGRES_USER=$POSTGRES_USER
ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD

WORKDIR /home/generator

RUN mkdir csv

RUN mkdir xml

COPY generator .

RUN pip install uv

RUN uv pip install --system -r requirements.txt

CMD ["python", "generate.py"]