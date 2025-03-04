FROM rasa/rasa:3.6.20

# Switch to root for setup
USER root

# Set working directory
WORKDIR /app

RUN pip install --no-cache-dir rasa-sdk==3.6.2

# Copy application code
COPY banking_chatbot /app/banking_chatbot

# Change to application directory
WORKDIR /app/banking_chatbot

# Create models directory with proper permissions
RUN mkdir -p /app/banking_chatbot/models && \
    chown -R 1001:1001 /app

# Switch back to non-root user (1001 is the default rasa user)
USER 1001

# Train the model (with fallback if already exists)
RUN rasa train || echo "Model already exists"

# The PORT environment variable will be used by Render
ENV PORT=5005

# Expose port for the application
EXPOSE 5005

# Command to run the application - FIXED
CMD ["run", "--enable-api", "--cors", "*", "--port", "5005", "--interface", "0.0.0.0"]