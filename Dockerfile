# 1. بيئة عمل بايثون مستقرة ومؤمنة
FROM python:3.11-slim

# 2. المسار التشغيلي الداخلي
WORKDIR /app

# 3. تحديث النظام وتثبيت الأدوات الحاكمة بأبسط صياغة
RUN apt-get update && apt-get install -y curl git && rm -rf /var/lib/apt/lists/*

# 4. نسخ المكونات وتثبيت المكتبات
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. نسخ باقي ملفات النظام إلى الحاوية
COPY . .

# 6. فتح منفذ واجهة المستخدم
EXPOSE 8501

# 7. أمر التشغيل المركزي
ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
