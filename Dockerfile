# 1. استخدام بيئة عمل بايثون مستقرة ومؤمنة
FROM python:3.11-slim

# 2. إعداد المسار التشغيلي الداخلي للحاوية
WORKDIR /app

# 3. تثبيت الأدوات الأساسية للنظام
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

# 4. نسخ ملف المتطلبات والمكتبات أولاً لتسريع بناء الـ Cache
COPY requirements.txt .

# 5. تثبيت حزم الاستدعاء ومحركات OpenAI البرمجية المعتمدة
RUN pip install --no-cache-dir -r requirements.txt

# 6. نسخ كافة ملفات التطبيق والمحركات إلى الحاوية السيادية
COPY . .

# 7. فتح البوابات والمنافذ الرقمية الحاكمة لواجهة المطور (Streamlit Port)
EXPOSE 8501

# 8. الفحص الدوري والمراقبة الذاتية لسلامة اتصال السيرفر (Healthcheck)
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl --fail http://localhost:8501/_stcore/health || exit 1

# 9. أمر التشغيل المركزي والنهائي للمنظومة
ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
