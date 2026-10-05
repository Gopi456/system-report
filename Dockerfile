FROM alpine:latest

WORKDIR /app

COPY report.sh .

RUN chmod +x report.sh

ENTRYPOINT ["./report.sh"]