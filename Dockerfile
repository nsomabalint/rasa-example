FROM rasa/rasa:latest

# Copy the chatbot files
COPY banking_chatbot /app/banking_chatbot
WORKDIR /app/banking_chatbot

# Train the model during build
RUN rasa train

# Expose the port
EXPOSE 5005

# Default command just to keep container alive
# Render's start command will override this
CMD ["tail", "-f", "/dev/null"]