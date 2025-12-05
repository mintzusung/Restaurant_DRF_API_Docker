# 使用你 Pipfile 指定的 Python 版本
FROM python:3.9-slim

# 設定工作目錄
WORKDIR /APIsProject

# 安裝必要系統套件（SQLite 已內建，不需要 Postgres client）
RUN apt-get update && apt-get install -y gcc && rm -rf /var/lib/apt/lists/*

# 安裝 pipenv
RUN pip install pipenv

# 複製 Pipfile & Pipfile.lock
COPY Pipfile Pipfile.lock ./

# 安裝專案套件（--system 直接裝到系統環境）
RUN pipenv install --system --deploy

# 複製 Django 專案
COPY . /APIsProject/

# 對外暴露 8000 端口
EXPOSE 8000

# 啟動 Gunicorn
CMD ["gunicorn", "APIsProject.wsgi:application", "--bind", "0.0.0.0:8000"]

