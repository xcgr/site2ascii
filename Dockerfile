# Python 3.10 tabanlı hafif bir Linux kullan
FROM python:3.10-slim

# Çıktıların anında terminale düşmesini sağlar
ENV PYTHONUNBUFFERED=1

# 1. Gerekli sistem araçlarını ve Google Chrome'u kur
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable

# 2. Çalışma klasörünü oluştur
WORKDIR /app

# 3. Kütüphaneleri yükle
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 4. Proje kodlarını kopyala
COPY . /app/

# 5. Gunicorn ile projeyi başlat (Buradaki 'proje_adiniz' kısmını kendi klasör adınla değiştir!)
CMD ["gunicorn", "site2ascii.wsgi:application", "--bind", "0.0.0.0:8000"]
