FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1

# Chrome ve gerekli kütüphanelerin kurulumu
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

# site2ascii projesini çalıştır
CMD ["gunicorn", "site2ascii.wsgi:application", "--bind", "0.0.0.0:8000"]
