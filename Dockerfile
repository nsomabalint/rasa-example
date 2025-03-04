FROM rasa/rasa:latest

USER root

WORKDIR /app

COPY banking_chatbot /app/banking_chatbot

WORKDIR /app/banking_chatbot

RUN mkdir -p /app/banking_chatbot/models && \
    chown -R 1001:1001 /app

USER 1001

RUN rasa train || echo "Model already exists"

EXPOSE 5005

# Default command just to keep container alive
# Render's start command will override this
CMD ["tail", "-f", "/dev/null"]