FROM python:3.9.16-slim
COPY ip_app/* /app
WORKDIR /app
RUN ["pip","install","-r","requirements.txt"]
EXPOSE 8080
CMD ["python", "./main.py"]