FROM python:3.9-slim

WORKDIR /app

# Create required directories with proper permissions
RUN mkdir -p /tmp/matplotlib /tmp/rasa && \
    chmod 777 /tmp/matplotlib /tmp/rasa

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY . /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Train a model
RUN mkdir -p models && \
    RASA_USER_HOME=/tmp/rasa rasa train
  
# Expose port for Rasa
EXPOSE 7860

# Start the app
CMD ["python", "app.py"]
