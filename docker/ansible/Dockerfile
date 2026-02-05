FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    sshpass \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# 確保 pip, setuptools 都是最新的
RUN pip install --no-cache-dir --upgrade pip setuptools

COPY requirements.txt /tmp/requirements.txt

# 合併安裝步驟，並直接使用 ansible-galaxy 指令
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    ansible-galaxy collection install google.cloud

WORKDIR /ansible