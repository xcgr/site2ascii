# "-slim" olmayan, tam sürüm Python kullanıyoruz. 
# Bu sürümde eksik araç sorunu yaşanmaz.
FROM python:3.10

ENV PYTHONUNBUFFERED=1

# 1. Sistemi güncelle ve temel araçları kur
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 2. Google Chrome'u DİREKT İNDİR ve KUR (Repo eklemekle uğraşma)
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get update && apt-get install -y ./google-chrome-stable_current_amd64.deb
RUN rm google-chrome-stable_current_amd64.deb

# 3. Çalışma alanını ayarla
WORKDIR /app

# 4. Kütüphaneleri yükle
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 5. Kodları kopyala
COPY . /app/

# 6. Uygulamayı başlat
CMD ["gunicorn", "site2ascii.wsgi:application", "--bind", "0.0.0.0:8000"]
