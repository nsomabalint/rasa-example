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

# Switch to the rasa user
USER 1001

# Train the model (will be skipped if models directory is not empty)
RUN rasa train || echo "Model already exists"

# Default port
EXPOSE 5005

# Use a direct command that reads the PORT environment variable
CMD PORT=${PORT:-5005} && rasa run --enable-api --cors "*" --port $PORT