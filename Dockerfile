FROM rasa/rasa:latest

USER root

WORKDIR /app

COPY banking_chatbot /app/banking_chatbot

WORKDIR /app/banking_chatbot

RUN mkdir -p /app/banking_chatbot/models && \
    chown -R 1001:1001 /app

# Create a startup script that respects the PORT environment variable
RUN echo '#!/bin/bash \n\
# Use PORT environment variable or default to 5005 \n\
PORT=${PORT:-5005} \n\
\n\
# Check if model exists, train if it doesn'\''t \n\
if [ ! -d "/app/banking_chatbot/models" ] || [ -z "$(ls -A /app/banking_chatbot/models)" ]; then \n\
  echo "Training model..." \n\
  rasa train \n\
fi \n\
\n\
echo "Starting Rasa server on port $PORT..." \n\
rasa run --enable-api --cors "*" --port $PORT "$@"' > /app/start.sh && \
    chmod +x /app/start.sh && \
    chown 1001:1001 /app/start.sh

# Switch to the rasa user
USER 1001

# Default port, but will be overridden by PORT env var in the script
EXPOSE 5005

# Use the start script instead of direct command
ENTRYPOINT ["/app/start.sh"]