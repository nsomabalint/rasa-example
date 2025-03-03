FROM rasa/rasa:latest

WORKDIR /banking_chatbot
COPY . /banking_chatbot

RUN rasa train

VOLUME /banking_chatbot/models

EXPOSE 5005

CMD ["run", "--enable-api", "--cors", "*"]