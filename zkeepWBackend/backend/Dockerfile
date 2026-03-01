FROM golang:1.25.2-alpine

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o api ./cmd

EXPOSE 8080

CMD ["./api"]