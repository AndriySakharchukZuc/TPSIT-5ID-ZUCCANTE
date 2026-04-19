# Этап 1: Сборка
FROM golang:1.26-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
# Собираем статически скомпилированный бинарник
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./cmd/main.go

# Этап 2: Финальный образ (миниатюрный)
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/

# Копируем только исполняемый файл из первого этапа
COPY --from=builder /app/server .
# Копируем .env или другие нужные конфиги, если они не проброшены через volumes
# COPY .env . 

# ГЛАВНОЕ: Команда для запуска приложения
CMD ["./server"]