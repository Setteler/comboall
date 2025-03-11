# Use Selenium Standalone Chrome as the base image
FROM python:3.9

# Set the working directory
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Selenium script into the container
COPY flaskapp.py /app/web.py
# Set the default command to run the script

EXPOSE 5050

CMD ["python3", "web.py"]
