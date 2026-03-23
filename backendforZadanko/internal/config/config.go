package config

import (
	"log"
	"os"
)

type Config struct {
	Port          string
	DatabaseURL   string
	JWTSecret     string
	FirebaseCreds string
}

func Load() *Config {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		log.Fatal("DATABASE_URL is required")
	}

	jwtSecret := os.Getenv("JWT_SECRET")
	if jwtSecret == "" {
		log.Fatal("JWT_SECRET is required")
	}

	firebaseCreds := os.Getenv("FIREBASE_CREDENTIALS_PATH")
	if firebaseCreds == "" {
		log.Fatal("FIREBASE_CREDENTIALS_PATH is required")
	}

	return &Config{
		Port:          port,
		DatabaseURL:   dbURL,
		JWTSecret:     jwtSecret,
		FirebaseCreds: firebaseCreds,
	}
}
