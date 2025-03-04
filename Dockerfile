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

COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

# Empty CMD that can be safely overridden
CMD []