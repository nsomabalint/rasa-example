FROM rasa/rasa:latest

# Start as root user to handle permissions
USER root

WORKDIR /app

# Copy the banking_chatbot directory to the container
COPY banking_chatbot /app/banking_chatbot

# Set working directory to the banking_chatbot folder
WORKDIR /app/banking_chatbot

# Create models directory with proper permissions
RUN mkdir -p /app/banking_chatbot/models

# Set proper permissions for the Rasa user
RUN chown -R 1001:1001 /app

# Switch to the rasa user (UID 1001)
USER 1001

# Train the model after we've set proper permissions
RUN if [ -f "config.yml" ]; then \
      rasa train; \
    else \
      echo "config.yml not found. Please ensure it exists in the banking_chatbot directory."; \
      exit 1; \
    fi

EXPOSE 5005

# Run the Rasa server
CMD ["run", "--enable-api", "--cors", "*"]