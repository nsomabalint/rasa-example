FROM rasa/rasa:latest

WORKDIR /app

# Copy the banking_chatbot directory to the container
COPY banking_chatbot /app/banking_chatbot

# Set working directory to the banking_chatbot folder
WORKDIR /app/banking_chatbot

# Check if config.yml exists before training
RUN if [ -f "config.yml" ]; then \
      rasa train; \
    else \
      echo "config.yml not found. Please ensure it exists in the banking_chatbot directory."; \
      exit 1; \
    fi

EXPOSE 5005

# Run the Rasa server
CMD ["run", "--enable-api", "--cors", "*"]