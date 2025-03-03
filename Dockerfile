FROM rasa/rasa:latest

USER root

WORKDIR /app

# Copy the banking_chatbot directory to the container
COPY banking_chatbot /app/banking_chatbot

# Set working directory to the banking_chatbot folder
WORKDIR /app/banking_chatbot

# Create models directory with proper permissions
RUN mkdir -p /app/banking_chatbot/models && \
    chown -R 1001:1001 /app

# Create a startup script that respects the PORT environment variable
RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'PORT=${PORT:-5005}' >> /app/start.sh && \
    echo '' >> /app/start.sh && \
    echo 'if [ ! -d "/app/banking_chatbot/models" ] || [ -z "$(ls -A /app/banking_chatbot/models)" ]; then' >> /app/start.sh && \
    echo '  echo "Training model..."' >> /app/start.sh && \
    echo '  rasa train' >> /app/start.sh && \
    echo 'fi' >> /app/start.sh && \
    echo '' >> /app/start.sh && \
    echo 'echo "Starting Rasa server on port $PORT..."' >> /app/start.sh && \
    echo 'rasa run --enable-api --cors "*" --port $PORT "$@"' >> /app/start.sh && \
    chmod +x /app/start.sh && \
    chown 1001:1001 /app/start.sh

# Switch to the rasa user
USER 1001

# Default port, but will be overridden by PORT env var in the script
EXPOSE 5005

# Use the start script instead of direct command
ENTRYPOINT ["/app/start.sh"]