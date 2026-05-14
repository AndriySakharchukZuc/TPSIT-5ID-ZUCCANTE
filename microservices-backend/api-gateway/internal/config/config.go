package config

import (
	"log"
	"os"
)

type Config struct {
	Port         string
	JWTSecret    string
	AuthService  string
	GroupService string
	TaskService  string
}

func Load() *Config {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}

	jwtSecret := os.Getenv("JWT_SECRET")
	if jwtSecret == "" {
		log.Fatal("JWT_SECRET is required")
	}

	return &Config{
		Port:         port,
		JWTSecret:    jwtSecret,
		AuthService:  getEnv("AUTH_SERVICE_URL", "http://auth-service:8080"),
		GroupService: getEnv("GROUP_SERVICE_URL", "http://group-service:8081"),
		TaskService:  getEnv("TASK_SERVICE_URL", "http://task-service:8082"),
	}
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
